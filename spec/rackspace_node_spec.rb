require 'rspec'
require 'rackspace'

describe Skewer::RackspaceNode do
  it "should build out a basic rackspace node" do
    lambda {
      Fog.mock!
      Skewer::RackspaceNode.new
    }.should raise_exception Fog::Errors::MockNotImplemented
  end
end
