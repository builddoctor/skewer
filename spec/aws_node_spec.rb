require 'rspec'
require 'fog'
require 'aws/node'

describe Skewer::AwsNode do
  it "should have an optional SSH key" do 
    lambda {
      Fog.mock!
      Skewer::AwsNode.new('ami-123456', ['default']).node
    }.should raise_exception Fog::Errors::MockNotImplemented

    lambda {
      Skewer::AwsNode.new('ami-123456', ['default'], { :key_name => 'FOO_BAR_KEY'})
    }.should raise_exception Fog::Compute::AWS::NotFound
  end
end
