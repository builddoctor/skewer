require 'rspec'
require 'skewer_config'

describe Skewer::Config do
  it "should only have one instance" do
    config1 = Skewer::Config.instance
    config2 = Skewer::Config.instance
    config1.should == config2
  end

  it "should have some default options" do
    config = Skewer::Config.instance
    config.get(:puppet_repo).should == '../infrastructure'
    config.get(:aws_region).should == 'us-east-1'
    config.get(:flavor_id).should == 'm1.large'
  end

  it "should parse json" do
    config = Skewer::Config.instance
    config.parse('{"seat_number": "29C"}')
    config.get(:seat_number).should == '29C'
  end

  it "should parse json and over-ride the defaults" do
    config = Skewer::Config.instance
    config.parse('{"fuel_type": "Unleaded", "puppet_repo": "/tmp/codez"}')
    config.get(:fuel_type).should == 'Unleaded'
    config.get(:puppet_repo).should == '/tmp/codez'
  end

  it "should have consistent getters and setters" do
    config = Skewer::Config.instance
    config.set(:test_key, 'test_value')
    config.get(:test_key).should == 'test_value'
  end
end
