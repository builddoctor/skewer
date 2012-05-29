require "rspec"
require 'skewer/hooks'

describe "Hooks" do

  it "should quietly go off and execute something" do

    hooks = Skewer::Hooks.new( 'foobar.build-doctor.com')
    hooks.command = 'echo doodoo'
    hooks.run.should == true
  end

  it "should not bother if there are no hooks" do


    hooks = Skewer::Hooks.new( 'foobar.build-doctor.com')
    hooks.run.should == false
  end
end