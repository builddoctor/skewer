require 'rubygems'
require 'fog'
"instantiates a eucalyptus endpoint"
class Eucalyptus

  def initialize


    compute = Fog::Compute.new(
        {
          :provider => 'AWS',
          :endpoint => 'http://localhost:4567'
        })
    @node = compute.servers.bootstrap()
    @node
    end

end
