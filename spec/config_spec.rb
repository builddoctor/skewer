require 'rspec'
require 'config'

describe Skewer::SkewerConfig do

  it "should have some default options" do
    config = Skewer::SkewerConfig.new
    config.get(:puppet_repo).should == '../infrastructure'
    config.get(:region).should == 'us-east-1'
    config.get(:flavor_id).should == 'm1.large'
  end

  it "should parse json" do
    config = Skewer::SkewerConfig.new
    config.parse('{"seat_number": "29C"}')
    config.get(:seat_number).should == '29C'
  end

  it "should parse json and over-ride the defaults" do
    config = Skewer::SkewerConfig.new
    config.parse('{"fuel_type": "Unleaded", "puppet_repo": "/tmp/codez"}')
    config.get(:fuel_type).should == 'Unleaded'
    config.get(:puppet_repo).should == '/tmp/codez'
  end

  it "should have consistent getters and setters" do
    config = Skewer::SkewerConfig.new
    config.set(:test_key, 'test_value')
    config.get(:test_key).should == 'test_value'
  end

  it "should be able to swallow options" do
     config = Skewer::SkewerConfig.new
     options = {'rodent' => 'bunnyrabbit', 'canine' => 'dingo' }
     config.slurp_options(options)
     config.get('rodent').should == 'bunnyrabbit'
     config.get('canine').should == 'dingo'
     config.get('region').should == 'us-east-1'
  end

  it "should take the region as a parameter" do
    config = Skewer::SkewerConfig.new
    config.set(:region, 'unknown region')
    config.get(:region).should == 'unknown region'
  end

  it "should have the region available as an attribute when slurped" do
    config = Skewer::SkewerConfig.new
    config.region.should == 'us-east-1'
    config.slurp_options({:region => 'eu-west-1'})
    config.region.should == 'eu-west-1'
  end

  it "should have a region accessor" do
    config = Skewer::SkewerConfig.new
    config.region.should == 'us-east-1'
  end

  it "should support some old options" do
    config = Skewer::SkewerConfig.new
    config.get(:puppet_repo).should == '../infrastructure'
    config.slurp_options({:puppetcode => '../foo'})
    config.get(:puppet_repo).should == '../foo'
  end

  it "should return an option if you don't have an accessor" do
    config = Skewer::SkewerConfig.new
    config.set('pint', 'Doom Bar')
    config.pint.should == 'Doom Bar'
  end
end
