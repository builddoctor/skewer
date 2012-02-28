#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

module Skewer
  class RackspaceNode
    attr_reader :node

    # By default, boot an Ubuntu 10.04 LTS (lucid) server.
    def initialize(flavor = 1, image = 112, name = 'my_server')
      connection = Fog::Compute.new(
        :provider => 'Rackspace',
        :rackspace_api_key  => Fog.credentials[:rackspace_api_key],
        :rackspace_username => Fog.credentials[:rackspace_username],
        :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"
      )

      # Get our SSH key to attach it to the server.
      path = File.expand_path '~/.ssh/id_rsa.pub'
      if File.exist?(path) == false
        path = File.expand_path '~/.ssh/id_dsa.pub'
        raise "Couldn't find a public key" if File.exist?(path) == false
      end

      file = File.open path
      key = file.read

      options = {
        :flavor_id  => flavor,
        :image_id   => image,
        :name       => name,
        :public_key => key
      }

      @node = connection.servers.bootstrap(options)
    end
  end
end
