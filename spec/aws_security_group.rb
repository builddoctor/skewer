require 'aws'

describe Skewer::AwsSecurityGroup do
  Fog.mock!
  it "should use an existing AWS service if it exists" do
    service = Skewer::AwsService.service
    group = Skewer::AwsSecurityGroup.new('foo','bar', {})
    group.service.should == service
  end

  it "should not open any extra ports if we don't ask" do 
    Skewer::AwsSecurityGroup.new('foo1','bar1', {}).group.ip_permissions.should == [] 
  end

  it "should open SSH by default" do
    AWSSservice.service.security_groups['default'].should == ['foo']
  end


end
