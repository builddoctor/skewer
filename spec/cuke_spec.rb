require 'rspec'
require 'cuke'

describe Skewer::Cuke do
  it "should only accept valid directories for construction" do
    lambda {
      Skewer::Cuke.new(nil)
    }.should raise_exception(RuntimeError, "you must provide a valid directory for features to be executed within")

    lambda {
      Skewer::Cuke.new(123)
    }.should raise_exception(RuntimeError, "you must provide a valid directory for features to be executed within")

    lambda {
      Skewer::Cuke.new('')
    }.should raise_exception(RuntimeError, "you must provide a valid directory for features to be executed within")

    lambda {
      Skewer::Cuke.new(123)
    }.should raise_exception(RuntimeError, "you must provide a valid directory for features to be executed within")

    lambda {
      Skewer::Cuke.new('./spec/dir_that_doenst_exist')
    }.should raise_exception(RuntimeError, "you must provide a valid directory for features to be executed within")
  end

  it "should build out the object if given a valid directory" do
    cuke = Skewer::Cuke.new('./spec')
    cuke.nil?.should == false
    cuke.class.should == Skewer::Cuke
  end
end
