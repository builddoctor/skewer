require 'cli'

describe Skewer::CLI do
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
end
