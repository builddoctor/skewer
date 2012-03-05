require "rspec"
require 'hooks'

describe "Hooks" do

  it "should quietly go off and execute something" do
    kernel = stub('kernel')
    kernel.should_receive(:exec).with(["ls", "foobar.build-doctor.com"])
    Skewer::Hooks.new("ls", 'foobar.build-doctor.com', kernel).run.should == nil
  end
end