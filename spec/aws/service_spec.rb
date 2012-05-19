require 'conf_helper'
require 'aws/service'
require 'fog'

describe Skewer::AWS::Service do
  it "should return an AWS instance" do
    Fog.mock!
    Skewer::AWS::Service.service.class.should == Fog::Compute::AWS::Mock
  end

  it "should register itself for reuse" do
    service = Skewer::AWS::Service.service
    ConfHelper.new.conf.get('aws_service').should == service
  end

  it "should take zone param from SkewerConfig, and raise exception if not supported" do
    ConfHelper.new.conf.set 'region', 'unknown region'

    lambda {
      service = Skewer::AWS::Service.service
    }.should raise_exception(ArgumentError, 'Unknown region: "unknown region"')
  end

  it "should take zone param from SkewerConfig" do
    Fog.mock!
    ConfHelper.new.conf.set 'region', 'eu-west-1'
    service = Skewer::AWS::Service.service
    service.nil?.should == false
    service.class.should == Fog::Compute::AWS::Mock
  end
end
