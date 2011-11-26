describe AwsSecurityGroup do 
  Fog.mock!
  it "should use an existing AWS service if it exists" do
    service = AwsService.service
    group = AwsSecurityGroup.new('foo','bar', {})
    group.service.should == service
  end

  it "should not open any extra ports if we don't ask" do 
    AwsSecurityGroup.new('foo1','bar1', {}).group.ip_permissions.should == [] 
  end


end
