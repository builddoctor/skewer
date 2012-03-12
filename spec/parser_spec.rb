require 'parser'

USAGE = <<EOF
Usage: skewer COMMAND [options]

The available skewer commands are:
   provision  spawn a new VM via a cloud system and provision it with puppet code
   update     update the puppet code on a machine that you've already provisioned
EOF
USAGE.strip!

describe Skewer::CLI::Parser do
  it "should barf if given no params" do
    lambda {
      parser = Skewer::CLI::Parser.new
    }.should raise_exception(RuntimeError, USAGE)
  end

  it "should only accept 'provision' and 'update' as types" do
    lambda {
      parser = Skewer::CLI::Parser.new('test', {:bloom => 'filter'})
    }.should raise_exception(RuntimeError, USAGE)
  end

  it "should build out the object if given correct input" do
    parser = Skewer::CLI::Parser.new('provision', {:kind => true, :image => true, :role => true})
    parser.nil?.should == false

    parser = Skewer::CLI::Parser.new('update', {:host => true, :user => true})
    parser.nil?.should == false
  end

  it "should raise a usage exception if using 'provision' without correct options" do
    lambda {
      parser = Skewer::CLI::Parser.new('provision', {:bloom => 'filter'})
    }.should raise_exception(RuntimeError, "Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>")
  end

  it "should raise a usage exception if using 'update' without correct options" do
    lambda {
      parser = Skewer::CLI::Parser.new('update', {:bloom => 'filter'})
    }.should raise_exception(RuntimeError, "Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>")
  end
end
