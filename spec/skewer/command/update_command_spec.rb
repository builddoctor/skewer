require "rspec"
require 'skewer/command/update'

describe "Update" do

  it "should blow up if it doesn't have options'" do
    lambda {
      Skewer::Command::Update.new({}, {})
    }.should raise_error RuntimeError
  end

  it "should blow up with a duff noop" do
    pending('later')
  end

  it "should blow up with a duff mock" do
    pending('later')
  end

  it "should inherit lots of good stuff" do
    Skewer::Command::Update.new({}, {:role => ' ', :user => ' ', :host => ' '}).class.superclass.should == Skewer::SkewerCommand
  end

  it "should delegate to something that is going to do the work" do
    pending('later')
  end


end