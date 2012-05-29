require 'rubygems'
require 'fog'

module Skewer
  # instantiates a eucalyptus endpoint
  class Eucalyptus
    def initialize
      compute = Fog::Compute.new({
        :provider => 'AWS',
        :endpoint => 'http://localhost:4567'
      })
      @node = compute.servers.bootstrap()
    end
  end
end
