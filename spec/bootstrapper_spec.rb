require 'bootstrapper'
require 'source'

describe Skewer::Bootstrapper do 
  it "should barf if the file doesn't exist" do
    lambda {
      Skewer::Bootstrapper.new(nil, {}).execute('oberon.sh')
    }.should raise_exception RuntimeError
  end

  it "should copy the rubygems profile.d script over" do
    node = mock('node')
    node.should_receive(:scp)
    node.should_receive(:ssh).with('sudo bash /var/tmp/rubygems.sh')
    Skewer::Bootstrapper.new(node, {}).execute('rubygems.sh')
  end

  it "should install rubygems on the remote machine" do 
    node = mock('node')
    node.should_receive(:scp).with("assets/Gemfile", "infrastructure")
    node.should_receive(:ssh).with('. /etc/profile.d/rubygems.sh && cd infrastructure && bundle install')
    Skewer::Bootstrapper.new(node, {}).install_gems
  end

  it "should make a node file if it can't find one" do
    FileUtils.mkdir_p('target/manifests')
    s = Skewer::Source.new('target')
    node  = stub('node')
    node.should_receive(:username).at_least(1).times
    node.should_receive(:dns_name).at_least(1).times
    node.should_receive(:ssh).at_least(1).times
    Skewer::Config.instance.set(:puppet_repo, 'target')
    lambda {
      Skewer::Bootstrapper.new(node, {:role => 'foo'}).sync_source
    }.should raise_exception RuntimeError
    Skewer::Config.instance.set(:puppet_repo, '../infrastructure')
    File.exist?('target/manifests/nodes.pp').should == true
    FileUtils
  end
end
