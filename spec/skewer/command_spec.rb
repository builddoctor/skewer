require "rspec"
require 'skewer/command'
require 'config'

describe "Commands" do

  it "should know about config" do

    Skewer::SkewerCommand.new({},{}).config.class.should == Skewer::SkewerConfig
  end

  it "should slurp all the options" do
    skewer_command = Skewer::SkewerCommand.new({:foo => 'bar'}, {:baz => 'goo'})
    skewer_command.config.get(:foo).should == 'bar'
    skewer_command.config.get(:baz).should == 'goo'
  end
end