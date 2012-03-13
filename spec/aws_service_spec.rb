require 'config'
require 'aws/service'
require 'fog'

describe Skewer::AwsService do
  it "should return an AWS instance" do
    Fog.mock!
    Skewer::AwsService.service.class.should == Fog::Compute::AWS::Mock
  end

  it "should register itself for reuse" do
    service = Skewer::AwsService.service
    Skewer::SkewerConfig.get('aws_service').should == service
  end

  it "should take zone param from SkewerConfig, and raise exception if not supported" do
    Skewer::SkewerConfig.set 'aws_region', 'unknown region'

    lambda {
      service = Skewer::AwsService.service
    }.should raise_exception(ArgumentError, 'Unknown region: "unknown region"')
  end

  it "should take zone param from SkewerConfig" do
    Fog.mock!
    Skewer::SkewerConfig.set 'aws_region', 'eu-west-1'
    service = Skewer::AwsService.service
    service.nil?.should == false
    service.class.should == Fog::Compute::AWS::Mock
  end
end
