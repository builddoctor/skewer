#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

module Skewer
  class RackspaceNode
    attr_reader :dns_name

    # By default, boot an Ubuntu 10.04 LTS (lucid) server.
    def initialize(flavor = 1, image = 49, name = 'my_server')
      connection = Fog::Compute.new(
        :provider => 'Rackspace',
        :rackspace_api_key  => Fog.credentials[:rackspace_api_key],
        :rackspace_username => Fog.credentials[:rackspace_username],
        :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"
      )

      options = {
        :flavor_id  => flavor,
        :image_id   => image,
        :name       => name,
        :public_key => ''
      }
      
      connection.servers.bootstrap(options)
    end
  end
end
