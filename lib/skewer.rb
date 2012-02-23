require 'rubygems'
require 'fog'

require 'bootstrapper'

module Skewer
  # this is responsible for composing all the other components. or should be.
  class Skewer
    attr_reader :bootstrapper, :node
    def initialize(options)
      @options = options
      @config = Config.instance
    end

    def select_node(kind)
      puts "Evaluating #{kind}"
      case kind
      when :ec2 
        require 'aws'
        puts 'Launching an EC2 node'
        aws_group = @options[:group]
        group = aws_group ? aws_group : 'default'
        node = AwsNode.new(@options[:image], nil, ['default'])
        #TODO: fix AwsNode, as it's evil
      when :rackspace
        require 'rackspace'
        puts 'Launching a Rackspace node'
        node = RackspaceNode.new(nil, @options[:image], 'default')
      when :linode
        #compute = Fog::Compute.new(@linode_creds)
        #node = compute.servers[0]
        #puts 'Finding an existing linode node'
        raise "not implemented"
      when :eucalyptus
        puts 'Using the EC2 API'
        require 'eucalyptus'
        node = Eucalyptus.new
      #when :ersatz
        #puts 'Launching a pretend node'
        #require 'ersatz/ersatz_node.rb'
        #node = ErsatzNode.new('localhost', ENV['USERNAME'])
      when :vagrant
        puts 'Launching a local vagrant node'
        require 'ersatz/ersatz_node.rb'
        node = ErsatzNode.new('default', 'vagrant')
      when :stub
        puts "launching stub one for testing"
        require 'stub_node'
        node = StubNode.new
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
      @bootstrapper.go
    end

    def go 
      require 'puppet'
      begin
        @node.wait_for { ready? }
        @bootstrapper.go
        result = Puppet.run(node, @options)

        node_dns_name = @node.dns_name
        puts "Node ready\n open http://#{node_dns_name} or \n ssh -l @node.username #{node_dns_name}"
      rescue Exception => exception
        puts exception
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
