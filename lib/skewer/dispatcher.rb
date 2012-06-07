require 'rubygems'
require 'fog'

require 'skewer/skewer'
require 'skewer/bootstrapper'
require 'skewer/hooks'

module Skewer
  # this is responsible for composing all the other components. or should be.
  class Dispatcher
    include Skewer
    attr_reader :bootstrapper, :node

    def initialize(options)
      @options = options
      config.slurp_options(options)
    end

    def select_strategy(option)
      require 'skewer/strategy/bundler'
      require 'skewer/strategy/debian_package'
      if option.to_sym == :bundler
        Skewer::Strategy::Bundler.new(@node)
      elsif option.to_sym == :debian
        Skewer::Strategy::DebianPackage.new(@node)
      else
        raise "I don't know about that strategy - sorry"
      end
    end


    def select_node(cloud)
      logger.debug "Evaluating cloud #{cloud}"
      image = @options[:image]
      case cloud.to_sym
        when :ec2
          require 'aws/security_group'
          require 'aws/node'
          require 'aws/service'
          logger.debug 'Launching an EC2 node'
          aws_group = @options[:group]
          group = aws_group ? aws_group : 'default'
          node = AWS::Node.new(image, [group]).node
        when :rackspace
          require 'rackspace/node'
          logger.debug 'Launching a Rackspace node'
          node = Rackspace::Node.new(config.get(:flavor_id), image, 'default').node
        when :linode
          raise "not implemented"
        when :eucalyptus
          logger.debug 'Using the EC2 API'
          require 'skewer/eucalyptus'
          node = Eucalyptus.new
        when :vagrant
          logger.debug 'Launching a local vagrant node'
          require 'skewer/ersatz/ersatz_node.rb'
          node = ErsatzNode.new('default', 'vagrant')
        when :stub
          logger.debug "Launching stubbed node for testing"
          require 'skewer/stub_node'
          node = StubNode.new
        when :ersatz
          require 'skewer/ersatz/ersatz_node.rb'
          node = ErsatzNode.new(config.get(:host), config.get(:user))
        else
          raise "I don't know that cloud"
      end
      node
    end

    def destroy
      @node.destroy unless @options[:keep]
    end

    def bootstrap
      node = select_node(@options[:cloud])
      @node = node
      @installer = select_strategy(config.get(:strategy))
      @bootstrapper = Bootstrapper.new(node, @installer, @options)
    end

    def go
      require 'skewer/puppet'
      require 'skewer/cuke'
      begin
        node = @node
        node.wait_for { ready? }
        @bootstrapper.go
        Puppet.run(node, @installer, @options)
        location = get_location(node)
        Hooks.new(location).run

        Cuke.new(@config.get(:cuke_dir), location).run if config.get(:cuke_dir)
        logger.info "Node ready\n open http://#{location} or \n ssh -l #{node.username} #{location}"
      rescue Exception => exception
        logger.debug exception
        raise "Something went wrong, and we killed the node"
      ensure
        destroy
      end
    end

    def self.bootstrap_and_go(options)
      skewer = self.new(options)
      skewer.bootstrap
      skewer.go
    end
  end
end
