require "rspec"
require "skewer/strategy/debian_package"

describe "Provision Puppet with Debian packages" do

  it "should install puppet via apt" do
    node = mock('node')
    node.should_receive(:ssh).with('sudo aptitude install puppet -y')
    Skewer::Strategy::DebianPackage.new(node).install
  end

  it "should know about the command" do
    Skewer::Strategy::DebianPackage.new(nil).executable.should == '/usr/bin/puppet'
  end
end
