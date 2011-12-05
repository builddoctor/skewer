require 'rspec'
require 'skewer_config'
describe SkewerConfig do 
  it "should only have one instance" do
    config1 = SkewerConfig.instance
    config2 = SkewerConfig.instance
    config1.should == config2
  end

end
