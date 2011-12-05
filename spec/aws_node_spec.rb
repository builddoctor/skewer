require 'rspec'
require 'skewer_config'
require 'aws'
describe AwsNode do 
  it "should have an optional SSH key" do 
    lambda { AwsNode.new('ami-123456', nil ,['default']) }.should raise_exception Fog::Errors::MockNotImplemented
    lambda { AwsNode.new('ami-123456', nil ,['default'], { :key_name => 'FOO_BAR_KEY'}) }.should raise_exception Fog::Compute::AWS::NotFound
  end
end
