require 'skewer'

describe Skewer do
  it "should have a logger object available on the module" do
    Skewer.logger.nil?.should == false
    Skewer.logger.class.should == Logger
  end

  it "should have a way to inject a new logger" do
    # Check that a Logger already exists.
    Skewer.logger.nil?.should == false
    Skewer.logger.class.should == Logger

    # Override the logger.
    Skewer.logger = String.new
    Skewer.logger.nil?.should == false
    Skewer.logger.class.should == String

    # Return the logger back to being Logger.
    Skewer.logger = Logger.new(STDOUT)
  end
end
