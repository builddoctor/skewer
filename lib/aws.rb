#!/usr/bin/env ruby
require 'rubygems'

require 'fog'
require 'config'

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

  def ensure_port_ranges(group, ports)
    ports.each do |port|

      description = port[:description]
      range = port[:range]
      options = port[:options]

      group.revoke_port_range(range)
      group.authorize_port_range(range, {:name => description})
      # TODO: get the port range options in there
    end
  end

  def initialize(name, desc, ports)
    @service ||= SkewerConfig.get 'aws_service'
    groups = @service.security_groups
    group = groups.select {|group | group.name == name }[0]
   
    if group.nil? == true
      group = @service.create_security_group(name , desc)
      group = groups.get(name)
    end
  end

    if ports.length >= 1
      ensure_port_ranges(group, ports)
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
