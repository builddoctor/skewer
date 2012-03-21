require 'rspec'
require 'fog'
require 'rackspace/images'

describe Skewer::Rackspace::Images do
  before(:each) do
    @images = Skewer::Rackspace::Images.new
  end

  it "should build out an object" do
    @images.nil?.should == false
  end

  it "should have a supported images hash associated with the hash" do
    @images.supported.class.should == Hash
  end

  it "should provide a default image ID if bad input provided" do
    @images.get_id(nil).should == 112
    @images.get_id(false).should == 112
    @images.get_id(true).should == 112
  end

  it "should raise an exception if a bad name is provided" do
    lambda {
      @images.get_id('bleep de bloop')
    }.should raise_exception(RuntimeError)
  end

  it "should return the ID if the correct name is provided" do
    @images.get_id('ubuntu1104').should == 115
  end

  it "should pass back an integer if given an integer" do
    @images.get_id(2324234).should == 2324234
  end
end
