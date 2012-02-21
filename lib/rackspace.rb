#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'

require 'fog'
#require 'config'

module Skewer
  class RackspaceNode

    def initialize
      connection = Fog::Compute.new(
        :provider => 'rackspace',
        :rackspace_api_key  => '',
        :rackspace_username => ''
      )

      # boot a gentoo server (flavor 1=256, image 3=gentoo 2008.0).
      server = connection.servers.create(
        :flavor_id => 1,
        :image_id  => 3,
        :name      => 'my_server'
      )
      
      # wait for it to be ready to do stuff.
      server.wait_for { ready? }
    end
  end
end
