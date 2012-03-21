require 'aws/security_group'
require 'fog'

describe Skewer::AWS::SecurityGroup do
  Fog.mock!
  it "should use an existing AWS service if it exists" do
    service = Skewer::AWS::Service.service
    group = Skewer::AWS::SecurityGroup.new('foo','bar', {})
    group.service.should == service
  end

  it "should not open any extra ports if we don't ask" do 
    Skewer::AWS::SecurityGroup.new('foo1','bar1', {}).group.ip_permissions.should == []
  end

  it "should open SSH by default" do
    default_group = Skewer::AWS::Service.service.security_groups.select {|group| group.name == 'default'}[0]
    default_group.ip_permissions.select {|dg| dg['fromPort'] == 22 && dg['toPort'] == 22 }.length.should == 1
  end
end
