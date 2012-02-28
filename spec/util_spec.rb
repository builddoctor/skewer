require 'rspec'
require 'fog'

require 'util'

describe Skewer::Util do
  it "should have a way to get the location" do
    util = Skewer::Util.new

    # Negative cases.
    util.get_location().should == nil
    util.get_location(nil).should == nil
    util.get_location(Object.new).should == nil

    aws = Object.new
    def aws.dns_name; return "aws-fqdn"; end

    rackspace = Object.new
    def rackspace.public_ip_address; return "1.1.1.1"; end
    
    # Positive cases.
    util.get_location(aws).should == 'aws-fqdn'
    util.get_location(rackspace).should == '1.1.1.1'
  end
end
