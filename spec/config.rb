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
    config.get(:flavor_id).should == 'm1.large'
  end

  it "should parse json" do 
    config = SkewerConfig.instance
    config.parse('{"seat_number": "29C"}')
    config.get(:seat_number).should == '29C'
  end

  it "should parse json and over-ride the defaults" do
    config = SkewerConfig.instance
    config.parse('{"fuel_type": "Unleaded", "puppet_repo": "/tmp/codez"}')
    config.get(:fuel_type).should == 'Unleaded'
    config.get(:puppet_repo).should == '/tmp/codez'
  end

end
