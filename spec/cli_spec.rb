require 'cli'

describe Skewer::CLI do
  before(:each) do
    config = Skewer::SkewerConfig.instance
    config.reset
  end

  Fog.mock!
  it "shouldn't barf if you instantiate it wthout options" do
    lambda {
      Skewer::CLI.new({:kind => :nil})
    }.should_not raise_exception
  end

  it "should blow up if you ask for Linode as it's not done" do
    lambda {
      Skewer::CLI.new({:kind => :nil}).select_node(:linode)
    }.should raise_exception RuntimeError
  end

  it "should return a node of type eucalytus if you ask for one" do
    lambda {
      Skewer::CLI.new({:kind => :nil}).select_node(:eucalyptus)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should return a node of type local if you ask for vagrant" do
    Skewer::CLI.new({:kind => :nil}).select_node(:vagrant).class.should == Skewer::ErsatzNode
  end

  it "should return a node of type AWS if you ask for one" do
    lambda {
      Skewer::CLI.new({:kind => :nil}).select_node(:ec2)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should be able to parse the options as they're given" do
    config = Skewer::SkewerConfig.instance
    config.get(:region).should == 'us-east-1'
    cli = Skewer::CLI.new({:kind => :nil, :region => 'eu-west-1'})
    config.get(:region).should == 'eu-west-1'
  end

  it "should be able to pass the region through to the AWS service" do
    config = Skewer::SkewerConfig.instance
    config.get(:region).should == 'us-east-1'
    cli = Skewer::CLI.new({:kind => :nil, :region => 'eu-west-1'})
    config.get(:region).should == 'eu-west-1'
    lambda {
      cli.select_node(:ec2)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end
end
