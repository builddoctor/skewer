require "rspec"
require 'skewer/command/update'

describe "Update" do

  it "should blow up if it doesn't have options'" do
    Skewer::Command::Update.new({}, {}).valid?[0].should be_false
  end

  it "should blow up with an invalid noop" do
    Skewer::Command::Update.new({:noop => 'cheese'}, {:role => ' ', :user => ' ', :host => ' '}).valid?[0].should be_false
  end

  it "should blow up with a invalid mock" do
    Skewer::Command::Update.new({:mock => 'beef'}, {:role => ' ', :user => ' ', :host => ' '}).valid?[0].should be_false
  end

  it "should be valid without stupid options" do
    Skewer::Command::Update.new({}, {:role => ' ', :user => ' ', :host => ' '}).valid?[0].should be_true
  end

  it "should inherit lots of good stuff" do
    Skewer::Command::Update.new({}, {:role => ' ', :user => ' ', :host => ' '}).class.superclass.should be Skewer::SkewerCommand
  end

  it "should delegate to something that is going to do the work" do
    pending('later')
  end


end