require 'aws/aws_service'
require 'fog'

describe Skewer::AwsService do
  it "should return an AWS instance" do
    Fog.mock!
    Skewer::AwsService.service.class.should == Fog::Compute::AWS::Mock
  end

  it "should register itself for reuse" do
    service = Skewer::AwsService.service
    Skewer::Config.get('aws_service').should == service
  end
end
