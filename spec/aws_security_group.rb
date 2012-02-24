
require 'aws/aws_security_group'
require 'fog'

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
    default_group = Skewer::AwsService.service.security_groups.select {|group| group.name == 'default'}[0]
    default_group.ip_permissions.select {|dg| dg['fromPort'] == 22 && dg['toPort'] == 22 }.length.should == 1
  end


end
