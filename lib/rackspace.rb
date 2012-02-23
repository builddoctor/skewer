#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'

require 'fog'
#require 'config'

module Skewer
  class RackspaceNode
    attr_reader :dns_name

    # By default, boot an Ubuntu 10.04 LTS (lucid) server.
    def initialize(flavor = 1, image = 49, name = 'my_server')
      connection = Fog::Compute.new(
        :provider => 'rackspace',
        :rackspace_api_key  => '',
        :rackspace_username => ''
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
