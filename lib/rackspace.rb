#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'

require 'fog'
#require 'config'

module Skewer
  class RackspaceNode
    attr_reader :dns_name

    # By default, boot a gentoo server (flavor 1=256,
    # image 3=gentoo 2008.0).
    def initialize
      connection = Fog::Compute.new(
        :provider => 'rackspace',
        :rackspace_api_key  => '',
        :rackspace_username => ''
      )

      options = {
        :flavor_id  => 1,
        :image_id   => 3,
        :name       => 'my_server',
        :public_key => ''
      }
      
      connection.servers.bootstrap(options)
    end
  end
end
