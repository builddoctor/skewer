#require 'util'
require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'util.rb')

class Testy
  include Skewer

  def location(arg)
    get_location(arg)
  end
end

class Rackspace
  def public_ip_address
    '1.1.1.1'
  end
end

describe "utils" do
  before(:all) do
    @testy = Testy.new
  end

  it "should cope with garbage" do
    @testy.location(nil).should == nil
    @testy.location(Object.new).should == nil
  end

  it "should deal with AWS nodes" do
    aws = mock('aws')
    aws.should_receive(:dns_name).and_return('aws-fqdn')
    @testy.location(aws).should == 'aws-fqdn'
  end

  it "should deal with rackspace nodes" do
    rackspace = Rackspace.new
    @testy.get_location(rackspace).should == '1.1.1.1'
  end
end
