require 'bootstrapper'
require 'source'
require 'config'

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
    node.should_receive(:scp).with(File.expand_path("./lib/../assets/Gemfile"), "infrastructure")
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
    Skewer::SkewerConfig.instance.set(:puppet_repo, 'target')
    lambda {
      Skewer::Bootstrapper.new(node, {:role => 'foo'}).sync_source
    }.should raise_exception RuntimeError
    Skewer::SkewerConfig.instance.set(:puppet_repo, '../infrastructure')
    File.exist?('target/manifests/nodes.pp').should == true
    FileUtils
  end

  it "should make an attempt to load the key so that we can rsync the code over" do
    kernel = stub('kernel')
    node = stub('node')
    kernel.should_receive(:system).and_return(true)
    faux_homedir = 'tmp/foo/.ssh'

    config = Skewer::SkewerConfig.instance

    config.set(:key_name, 'my_great_test_key' )
    FileUtils.mkdir_p(faux_homedir)
    FileUtils.touch("#{faux_homedir}/my_great_test_key.pem")

    bootstrapper = Skewer::Bootstrapper.new(node, {})
    bootstrapper.add_key_to_agent(kernel, 'tmp/foo')
    Skewer::SkewerConfig.set(:key_name, nil)


  end

  it "should always run if there is no lock file" do
    node  = stub('node')
    node.should_receive(:dns_name).at_least(1).times.and_return('foo.bar.com')

    bootstrapper = Skewer::Bootstrapper.new(node, {:role => 'foo'})
    bootstrapper.destroy_lock_file

    bootstrapper.should_i_run?.should == true
    File.unlink(bootstrapper.lock_file)
    bootstrapper.should_i_run?.should == true

  end

  it "should let me know if it has just run" do
    node  = stub('node')
    node.should_receive(:dns_name).at_least(1).times.and_return('foo.bar.com')

    bootstrapper = Skewer::Bootstrapper.new(node, {:role => 'foo'})
    bootstrapper.destroy_lock_file

    bootstrapper.should_i_run?.should == true
    bootstrapper.should_i_run?.should == false
    bootstrapper.should_i_run?.should == false
  end

  it "should not bother bootstrapping again if it has bootstrapped recently" do
    node  = stub('node')
    node.should_receive(:scp).at_least(1).times
    node.should_receive(:ssh).at_least(1).times
    node.should_receive(:dns_name).at_least(1).times.and_return('foo.bar.com')
    bootstrapper = Skewer::Bootstrapper.new(node, {:role => 'foo'})
    bootstrapper.destroy_lock_file
    bootstrapper.mock = true
    bootstrapper.go
    sleep 1
    bootstrapper.go
  end

  it "should allow mocking out of the source step" do
    node  = stub('node')
    node.should_not_receive(:username)
    bootstrapper = Skewer::Bootstrapper.new(node, {:role => 'foo'})
    bootstrapper.mock = true
    bootstrapper.sync_source
  end

  it "should actually run the source step" do
    node  = stub('node')
    node.should_receive(:username).at_least(2).times
    node.should_receive(:ssh)
    bootstrapper = Skewer::Bootstrapper.new(node, {:role => 'foo'})
    lambda {
      bootstrapper.sync_source
    }.should  raise_exception RuntimeError
  end
end
