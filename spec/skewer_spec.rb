require 'skewer'
describe "skewer" do 
  it "should have a bootstrapper" do
    Skewer.new.bootstrapper.class.should == Bootstrapper 
  end

  it "should return a node of type AWS if you ask for one" do 
    Fog.mock!
    lambda { Skewer.new.select_node(:ec2).should == Server }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should blow up if you ask for Linode as it's not done" do
    lambda { Skewer.new.select_node(:linode).should == Server }.should raise_exception RuntimeError
  end

  it "should return a node of type eucalytus if you ask for one" do 
    lambda { Skewer.new.select_node(:eucalyptus).should == Server }.should raise_exception Fog::Errors::MockNotImplemented
  end

end
