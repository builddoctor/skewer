require 'cli'

describe Skewer::Dispatcher do
  before(:each) do
    config = Skewer::SkewerConfig.instance
    config.reset
  end

  Fog.mock!
  it "shouldn't barf if you instantiate it wthout options" do
    lambda {
      Skewer::Dispatcher.new({:cloud => :nil})
    }.should_not raise_exception
  end

  it "should blow up if you ask for Linode as it's not done" do
    lambda {
      Skewer::Dispatcher.new({:cloud => :nil}).select_node(:linode)
    }.should raise_exception RuntimeError
  end

  it "should return a node of type eucalytus if you ask for one" do
    lambda {
      Skewer::Dispatcher.new({:cloud => :nil}).select_node(:eucalyptus)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should return a node of type local if you ask for vagrant" do
    Skewer::Dispatcher.new({:cloud => :nil}).select_node(:vagrant).class.should == Skewer::ErsatzNode
  end

  it "should return a node of type AWS if you ask for one" do
    lambda {
      Skewer::Dispatcher.new({:cloud => :nil}).select_node(:ec2)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should be able to parse the options as they're given" do
    config = Skewer::SkewerConfig.instance
    config.get(:region).should == 'us-east-1'
    cli = Skewer::Dispatcher.new({:cloud => :nil, :region => 'eu-west-1'})
    config.get(:region).should == 'eu-west-1'
  end

  it "should be able to pass the region through to the AWS service" do
    config = Skewer::SkewerConfig.instance
    config.get(:region).should == 'us-east-1'
    cli = Skewer::Dispatcher.new({:cloud => :nil, :region => 'eu-west-1'})
    config.get(:region).should == 'eu-west-1'
    lambda {
      cli.select_node(:ec2)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should be able to pass the flavor_id through to the AWS service" do
    config = Skewer::SkewerConfig.instance
    config.get(:flavor_id).should == 'm1.large'
    cli = Skewer::Dispatcher.new({:cloud => :nil, :flavor_id => 'm1.small'})
    config.get(:flavor_id).should == 'm1.small'
    lambda {
      cli.select_node(:ec2)
    }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should be able to provide a cuke directory" do
    config = Skewer::SkewerConfig.instance
    config.get(:cuke_dir).should == nil
    cli = Skewer::Dispatcher.new({:cloud => :nil, :cuke_dir => 'spec'})
    config.get(:cuke_dir).should == 'spec'
  end
end
