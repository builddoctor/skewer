require 'rspec'
require 'rackspace'

describe Skewer::RackspaceNode do
  it "should build out a basic rackspace node" do
      Fog.mock!
      Skewer::RackspaceNode.new
  end
end
