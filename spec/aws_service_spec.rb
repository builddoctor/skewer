require 'aws'
require 'fog'
describe AwsService do
  it "should return an AWS instance" do 
    AwsService.service.class.should == Fog::Compute::AWS::Mock
  end

  it "should register itself for reuse" do
    service = AwsService.service
    SkewerConfig.get('aws_service').should == service
  end

end
