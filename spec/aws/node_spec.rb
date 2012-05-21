require 'rspec'
require 'fog'
require 'aws/node'
require 'conf_helper'

describe Skewer::AWS::Node do
  it "should have an optional SSH key" do
    lambda {
      Fog.mock!
      Skewer::AWS::Node.new('ami-123456', ['default']).node
    }.should raise_exception Fog::Errors::MockNotImplemented

    begin
      Skewer::AWS::Node.new('ami-123456', ['default'], {:key_name => 'FOO_BAR_KEY'})
    rescue Fog::Compute::AWS::NotFound => e
      e.message.should == "The key pair 'FOO_BAR_KEY' does not exist"
    end
  end

  it "should get the SSH key via config" do
    ConfHelper.new.conf.set(:key_name, 'FRONT_DOOR')
    begin
      Skewer::AWS::Node.new('ami-123456', ['default']).inspect
    rescue Fog::Compute::AWS::NotFound => e
      e.message.should == "The key pair 'FRONT_DOOR' does not exist"
    end
  end

  it "should be able to find the node by name" do
    options = {}
    service = stub('aws_service')
    servers = stub('aws_servers')
    service.should_receive(:servers).and_return(servers)
    servers.should_receive(:select).and_return([])
    Skewer::AWS::Node.find_by_name('foobar', service)
  end

  it "should be able in inject the AWS service" do
    options = {}
    service = stub('aws_service')
    servers = stub('aws_servers')

    service.should_receive(:servers).and_return(servers)
    servers.should_receive(:bootstrap)

    options[:service] = service
    Skewer::AWS::Node.new('ami-goo', ['default'], options)
  end

  it "should have a delete method" do
    options = {}
    service = stub('aws_service')
    servers = stub('aws_servers')
    node = stub('aws_node')

    service.should_receive(:servers).and_return(servers)
    servers.should_receive(:bootstrap).and_return(node)
    node.should_receive(:delete).and_return(true)

    options[:service] = service
    Skewer::AWS::Node.new('ami-goo', ['default'], options).node.delete.should == true
  end

  it "should have a static find_service method" do
    options = {}
    service = stub('aws_service')
    options[:service] = service
    Skewer::AWS::Node.find_service(options).should == service
  end
end
