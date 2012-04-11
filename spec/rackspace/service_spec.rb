require "rspec"
require 'rackspace/service'

describe "Rackspace::Service" do

  it "should return the london endpoint if you ask for lon" do
    Skewer::Rackspace::Service.new(nil).region('lon').should == 'lon.auth.api.rackspacecloud.com'
    Skewer::Rackspace::Service.new(nil).region(:lon).should == 'lon.auth.api.rackspacecloud.com'
  end

  it "should default to the US endpoint" do
    Skewer::Rackspace::Service.new(nil).region().should == 'auth.api.rackspacecloud.com'
  end

  it "should even give you the US endpoint if something else leaks" do
    Skewer::Rackspace::Service.new(nil).region('us-east-1').should == 'auth.api.rackspacecloud.com'
  end

end