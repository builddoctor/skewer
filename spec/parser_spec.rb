require 'parser'

USAGE = <<EOF
Usage: skewer COMMAND [options]

The available skewer commands are:
   provision  spawn a new VM via a cloud system and provision it with puppet code
   update     update the puppet code on a machine that you've already provisioned
EOF
USAGE.strip!

UPDATE_USAGE = "Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>"
PROVISION_USAGE = "Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>"
DELETE_USAGE = "Usage: skewer delete --cloud <which cloud> --host <host>"

describe Skewer::CLI::Parser do
  it "should barf if given no params" do
    lambda {
      parser = Skewer::CLI::Parser.new
    }.should raise_exception(SystemExit, USAGE)
  end

  it "should only accept 'provision' and 'update' as types" do
    lambda {
      parser = Skewer::CLI::Parser.new('test', {:bloom => 'filter'})
    }.should raise_exception(SystemExit, USAGE)
  end

  it "should barf if it doesnt know how to provision something odd" do
    lambda {
      parser = Skewer::CLI::Parser.new('provision', {:kind => "FOOBAR", :image => true, :role => true})
    }.should raise_exception(RuntimeError, "I don't know that cloud")

  end
  it "should barf if it doesn't know how to update something odd" do
    lambda {
      parser = Skewer::CLI::Parser.new('update', {:host => "googoo", :user => "shoopidoop"})
    }.should raise_exception(RuntimeError, "I don't know that cloud")
  end

  it "should raise a usage exception if using 'provision' without correct options" do
    lambda {
      parser = Skewer::CLI::Parser.new('provision', {:bloom => 'filter'})
    }.should raise_exception(SystemExit, PROVISION_USAGE)
  end

  it "should raise a usage exception if using 'update' without correct options" do
    lambda {
      parser = Skewer::CLI::Parser.new('update', {:bloom => 'filter'})
    }.should raise_exception(SystemExit, UPDATE_USAGE)
  end

  it "should show the main usage message if provided the help option" do
    lambda {
      parser = Skewer::CLI::Parser.new(false, {:help => true})
    }. should raise_exception(SystemExit, USAGE)
  end

  it "should show the provision usage message if provided 'provision' with the help option" do
    lambda {
      parser = Skewer::CLI::Parser.new('provision', {:kind => true, :image => true, :role => true, :help => true})
    }.should raise_exception(SystemExit, PROVISION_USAGE)
  end

  it "should show the update usage message if provided 'update' with the help option" do
    lambda {
      parser = Skewer::CLI::Parser.new('update', {:host => true, :user => true, :help => true})
    }.should raise_exception(SystemExit, UPDATE_USAGE)
  end

  it "should require --key if cloud is AWS" do
    lambda {
      parser = Skewer::CLI::Parser.new('provision', {:kind => :ec2})
    }.should raise_exception(SystemExit, "A key (--key KEY) must be provided if using EC2")
  end

  it "should show the delete usage if provided 'delete' with the help option" do
    lambda {
      parser = Skewer::CLI::Parser.new('delete', {:host => true, :kind => true, :help => true})
    }.should raise_exception(SystemExit, DELETE_USAGE)
  end

  it "should show the delete usage if not given the correct inputs" do
    lambda {
      parser = Skewer::CLI::Parser.new('delete', {:host => true})
    }.should raise_exception(SystemExit, DELETE_USAGE)

    lambda {
      parser = Skewer::CLI::Parser.new('delete', {:kind => true})
    }.should raise_exception(SystemExit, DELETE_USAGE)
  end
end
