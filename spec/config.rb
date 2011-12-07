require 'rspec'
require 'skewer_config'
describe SkewerConfig do 
  it "should only have one instance" do
    config1 = SkewerConfig.instance
    config2 = SkewerConfig.instance
    config1.should == config2
  end

  it "should have some default options" do 
    config = SkewerConfig.instance
    config.get(:puppet_repo).should == '../infrastructure'
    config.get(:aws_region).should == 'us-east-1'
    config.get(:flavour_id).should == 'm1.large'
  end

end
