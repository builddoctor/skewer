require 'rspec'
require 'rackspace/node'

describe Skewer::Rackspace::Node do
  it "should build out a basic rackspace node" do
    lambda {
      Fog.mock!
      Skewer::Rackspace::Node.new
    }.should raise_exception Fog::Errors::MockNotImplemented
  end
end
