require 'rubygems'
require 'fog'

require 'skewer'
require 'bootstrapper'
require 'util'
require 'hooks'

module Skewer
  # this is responsible for composing all the other components. or should be.
  class CLI
    attr_reader :bootstrapper, :node

    def initialize(options)
      @options = options
      @config = SkewerConfig.instance
      @config.slurp_options(options)
      @util = Util.new
      @config.set(:logger, Skewer.logger)
    end

    def select_node(kind)
      Skewer.logger.debug "Evaluating cloud #{kind}"
      image = @options[:image]
      case kind
        when :ec2
          require 'aws/security_group'
          require 'aws/node'
          require 'aws/service'
          Skewer.logger.debug 'Launching an EC2 node'
          aws_group = @options[:group]
          group = aws_group ? aws_group : 'default'
          node = AWS::Node.new(image, [group]).node
        when :rackspace
          require 'rackspace/node'
          Skewer.logger.debug 'Launching a Rackspace node'
          node = Rackspace::Node.new(@options[:flavor_id], image, 'default').node
        when :linode
          raise "not implemented"
        when :eucalyptus
          Skewer.logger.debug 'Using the EC2 API'
          require 'eucalyptus'
          node = Eucalyptus.new
        when :vagrant
          Skewer.logger.debug 'Launching a local vagrant node'
          require 'ersatz/ersatz_node.rb'
          node = ErsatzNode.new('default', 'vagrant')
        when :stub
          Skewer.logger.debug "Launching stubbed node for testing"
          require 'stub_node'
          node = StubNode.new
        when :ersatz
          require 'ersatz/ersatz_node.rb'
          node = ErsatzNode.new(@config.get('host'), @config.get('user'))
        else
          raise "I don't know that cloud"
      end
      node
    end

    def destroy
      @node.destroy unless @options[:keep]
    end

    def bootstrap
      node = select_node(@options[:kind])
      @node = node
      @bootstrapper = Bootstrapper.new(node, @options)
    end

    def go
      require 'puppet'
      require 'cuke'
      begin
        node = @node
        node.wait_for { ready? }
        @bootstrapper.go
        Puppet.run(node, @options)
        location = @util.get_location(node)
        Hooks.new(location).run
        Skewer.logger.debug "Node ready\n open http://#{location} or \n ssh -l #{node.username} #{location}"
        Cuke.new(@config.get(:cuke_dir)).run if @config.get(:cuke_dir)
      rescue Exception => exception
        Skewer.logger.debug exception
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
