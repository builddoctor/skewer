require "rspec"
require "skewer/strategy/bundler"

describe "Provision Puppet with Bundler" do

  it "should barf if the file doesn't exist" do
    lambda {
      Skewer::Strategy::Bundler.new(nil).execute('oberon.sh')
    }.should raise_exception RuntimeError
  end

  it "should copy the rubygems profile.d script over" do
    node = mock('node')
    node.should_receive(:scp)
    node.should_receive(:ssh).with('sudo bash /var/tmp/rubygems.sh')
    Skewer::Strategy::Bundler.new(node).execute('rubygems.sh')
  end

  it "should install rubygems on the remote machine" do
    node = mock('node')
    node.should_receive(:scp).with(File.expand_path("./lib/../assets/Gemfile"), "infrastructure")
    node.should_receive(:ssh).with('. /etc/profile.d/rubygems.sh && cd infrastructure && bundle install')
    Skewer::Strategy::Bundler.new(node).install_gems
  end

  it "should default to using bundler from /usr/local" do
    pending('Hard to test things that hit the FS')
    require 'skewer'
    node = mock('node')
    Skewer::Strategy::Bundler.new(node).locate_bundler('/usr/local/bin/bundle').should == '/usr/local/bin/bundle exec'
  end
end
