require 'skewer'
describe "skewer" do 

  it "shouldn't barf if you instantiate it wthout options" do 
    lambda { Skewer.new({:kind => :nil }) }.should_not raise_exception
  end

  it "should return a node of type AWS if you ask for one" do 
    Fog.mock!
    lambda { Skewer.new({:kind => :nil }).select_node(:ec2).should == Server }.should raise_exception Fog::Errors::MockNotImplemented
  end

  it "should blow up if you ask for Linode as it's not done" do
    lambda { Skewer.new({:kind => :nil }).select_node(:linode).should == Server }.should raise_exception RuntimeError
  end
  it "should return a node of type eucalytus if you ask for one" do 
    lambda { Skewer.new({:kind => :nil}).select_node(:eucalyptus).should == Server }.should raise_exception Fog::Errors::MockNotImplemented
  end

end
