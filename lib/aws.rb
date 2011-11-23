#!/usr/bin/env ruby
require 'rubygems'

require 'fog'

class AwsService
  attr_reader :service
  def initialize(zone = 'us-east-1')
    @service = Fog::Compute.new({
      :provider   => 'AWS',
      :region     => zone
    })
  end
end

class AwsSecurityGroup
  attr_reader :group
  attr_reader :name

  def initialize(name, desc, ports)
    service  = AwsService.new.service
    groups = service.security_groups
    group = groups.select {|g| g.name == name }[0]
   
    if group.nil? == true
      group = service.create_security_group(name , desc)
      group = service.security_groups.get(name)
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
  attr_reader :node
#TODO: pull out options, and read from CLI or json config file
  def initialize(aws_id, tier, group_names )
    service = AwsService.new.service
    @node = service.servers.bootstrap({
    :image_id       => aws_id ,
    :flavor_id      => 'm1.large',
    :username       => 'ubuntu',
    :key_name       => 'CI_FARM',
    :groups         => group_names
  })
 
  
  end
  
  def self.node(aws_id, tier, group_name)
    self.new(aws_id, tier, group_name)
  end
  
end


