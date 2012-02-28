require 'rspec'
require 'fog'
require 'aws/node'
require 'config'

describe Skewer::AwsNode do
  it "should have an optional SSH key" do 
    lambda {
      Fog.mock!
      Skewer::AwsNode.new('ami-123456', ['default']).node
    }.should raise_exception Fog::Errors::MockNotImplemented

   begin
    Skewer::AwsNode.new('ami-123456', ['default'], { :key_name => 'FOO_BAR_KEY'})
   rescue Fog::Compute::AWS::NotFound => e
     e.message.should == "The key pair 'FOO_BAR_KEY' does not exist"
   end

 end
 it "should get the SSH key via config" do
   Skewer::SkewerConfig.set('key_name', 'FRONT_DOOR')
   begin
    Skewer::AwsNode.new('ami-123456', ['default']).inspect
   rescue Fog::Compute::AWS::NotFound => e
        e.message.should == "The key pair 'FRONT_DOOR' does not exist"
   end

 end

end
