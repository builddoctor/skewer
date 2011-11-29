require 'rubygems'
require 'fog'

def create_local_node
  compute = Fog::Compute.new({
    :provider => 'AWS',
    :endpoint => 'http://localhost:4567'
  })
  node = compute.servers.bootstrap()
end
