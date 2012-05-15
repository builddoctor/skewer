require "rspec"
require 'skewer/command/provision'

describe "Provision" do

  it "should blow up if it doesn't have options'" do
    Skewer::Command::Provision.new({}, {}).valid?[0].should be_false
  end

  it "should blow up with an invalid noop" do
    Skewer::Command::Provision.new({:noop => 'cheese'}, {:role => 'foo', :cloud => :aws, :key => 'foo'}).valid?[0].should be_false
  end

  it "should blow up with a invalid mock" do
    Skewer::Command::Provision.new({:mock => 'beef'}, {:role => 'foo', :cloud => :aws, :key => 'foo'}).valid?[0].should be_false
  end

  it "should be valid without stupid options" do
    command_update_new = Skewer::Command::Provision.new({}, {:role => 'foo', :cloud => :aws, :image => 'foo'})
    command_update_new.valid?[0].should be_true
  end

  it "should inherit lots of good stuff" do
    Skewer::Command::Provision.new({}, {:role => 'foo', :cloud => :aws, :key => 'foo'}).class.superclass.should be Skewer::SkewerCommand
  end

end