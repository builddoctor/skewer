require 'skewer/puppet'

describe Skewer::Puppet do

  before(:each) do
    @puppet = Skewer::Puppet.new
    @root = File.expand_path File.join(File.dirname(__FILE__), "..")
    @prefix = "cd infrastructure && /var/lib/gems/1.8/bin/bundle exec puppet apply manifests/site.pp --color false"
    @sudo_prefix = "cd infrastructure && sudo /var/lib/gems/1.8/bin/bundle exec puppet apply manifests/site.pp --color false"
  end

  it "should sudo when connecting as root" do
    @puppet.command_string('goober', {}).should == "#{@sudo_prefix} --modulepath modules --vardir /var/lib/puppet"
  end

  it "should not pass a certname if you give it a role" do
    @puppet.command_string('goober', {:role => 'graunch'}).should == "#{@sudo_prefix} --modulepath modules --vardir /var/lib/puppet"
  end

  it "should not sudo when connecting as root" do
    @puppet.command_string('root', {}).should == "#{@prefix} --modulepath modules --vardir /var/lib/puppet"
  end

  it "should pass noop when if you pass the option" do
    @puppet.command_string('root', {:noop => true}).should == "#{@prefix} --modulepath modules --vardir /var/lib/puppet --noop"
  end

  it "should have args for our custom modulepath" do
    @puppet.arguments.should match(/modulepath/)
  end

  it "should not have args for external node configuration" do
    @puppet.arguments.should_not match(/external_nodes/)
  end

  it "should blow up if something fails" do 
    node = mock('node')
    result = stub('result')
    result.stub!('status').and_return(1)
    result.stub!('command').and_return('sys-unconfig')
    result.stub!('stdout').and_return('failure on stdout')
    result.stub!('stderr').and_return('failure on stderr')
    node.should_receive(:username).and_return('danmadams')
    node.should_receive(:ssh).and_return([result])
    lambda { @puppet.run(node, {})  }.should raise_exception Skewer::PuppetRuntimeError
  end
end
