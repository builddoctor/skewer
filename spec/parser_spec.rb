require 'parser'

describe Skewer::CLI::Parser do
  it "should barf if given no params" do
    lambda {
      parser = Skewer::CLI::Parser.new
    }.should raise_exception(RuntimeError, "Skewer::CLI::Parser requires a type and options hash.")
  end

  it "should only accept 'provision' and 'update' as types" do
    # Negative case.
    lambda {
      parser = Skewer::CLI::Parser.new('test', {:bloom => 'filter'})
    }.should raise_exception(RuntimeError, "The only types accepted are 'provision' and 'update'\nUsage: skewer provision|update")

    # Positive case (builds object).
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
