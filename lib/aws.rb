#!/usr/bin/env ruby
require 'rubygems'

require 'fog'
require 'skewer_config'

module Skewer
  # responsible for making the AWS service
  class AwsService
    attr_reader :service
    def initialize()
      zone = Config.get('aws_region')
      @service = Fog::Compute.new({
        :provider   => 'AWS',
        :region     => zone
      })
      Config.set 'aws_service', @service
      puts @service.inspect
    end

    def self.service
      self.new.service
    end
  end

  # responsible for making security groups
  class AwsSecurityGroup
    attr_reader :group
    attr_reader :name
    attr_reader :service

    def initialize(name, desc, ports)
      @service ||= Config.get 'aws_service'
      groups = @service.security_groups
      group = groups.select {|group | group.name == name }[0]
      
      if group.nil? == true
        group = @service.create_security_group(name , desc)
        group = groups.get(name)
      end

      if ports.length >= 1
        ports.each do |port|
          description = port[:description]
          range = port[:range]
          options = port[:options]
          
          group.revoke_port_range(range)
          group.authorize_port_range(range, {:name => description })
          # TODO: get the port range options in there
        end
      end
      @group = group
      @name = name
    end
  end

  class AwsNode
    def initialize(aws_id, tier, group_names, options = {} )
      @service = AwsService.new.service
      node_options  = {
        :image_id       => aws_id ,
        :flavor_id      => Config.get('flavor_id'),
        :username       => Config.get('aws_username'),
        :groups         => group_names
      }
      key_name = options[:key_name]
      node_options[:key_name] = key_name if key_name
      @service.servers.bootstrap(node_options)
    end
  end
end
