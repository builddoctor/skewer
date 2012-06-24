require 'skewer/puppet'

class ConfigProxy
  # TODO: work out why rspec tests can't load the skewer module'
  include Skewer
  def set(var, val)
    config.set(var, val)
  end
end

describe Skewer::Puppet do

  before(:each) do
    installer = stub('installer')
    installer.should_receive(:executable).and_return('/usr/local/bin/bundle exec')
    @puppet = Skewer::Puppet.new(installer)
    @root = File.expand_path File.join(File.dirname(__FILE__), "..")
    @prefix = "cd infrastructure && /usr/local/bin/bundle exec puppet apply manifests/site.pp --color false"
    @sudo_prefix = "cd infrastructure && sudo /usr/local/bin/bundle exec puppet apply manifests/site.pp --color false"
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

  it "should have a variable puppet manifest path" do
    require 'skewer/skewer'
    ConfigProxy.new.set :manifestpath, 'my_great_manifests/main.pp'
    prefix = "cd infrastructure && /usr/local/bin/bundle exec puppet apply my_great_manifests/main.pp --color false"
    @puppet.command_string('root', {}).should == "#{prefix} --modulepath modules --vardir /var/lib/puppet"

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
    begin
      @puppet.run(node, {})
    rescue Exception => e
     e.message.should == 'Puppet failed'
    end
  end
end
