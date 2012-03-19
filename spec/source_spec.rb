require 'source'

describe Skewer::Source do
  it "should have a source directory that exists" do
    lambda {
      Skewer::Source.new('/tmp')
    }.should_not raise_exception RuntimeError

    lambda {
      Skewer::Source.new('/dev/boomlakkalakka/boomlakkalakka')
    }.should raise_exception RuntimeError
  end

  it "should exclude git from the upload list" do
    Skewer::Source.new('/tmp').excludes.should include '.git'
  end

  it "should make a parent directory to shut rsync up" do
    node = mock('node')
    node.should_receive(:dns_name).at_least(3).times.and_return('this.should.not.resolve')
    node.should_receive(:username).at_least(3).times.and_return('jimmy')
    node.should_receive(:ssh)
    source = Skewer::Source.new('/tmp/')
    lambda { source.rsync(node) }.should raise_exception RuntimeError
  end

  it "should rsync the source tree to the remote node" do
    node = mock('node')
    node.should_receive(:dns_name).and_return('foo.foo.com')
    node.should_receive(:username).and_return('jimmy')
    source = Skewer::Source.new('/tmp/')
    source.rsync_command(node).should == 'rsync --exclude Gemfile --exclude Gemfile.lock --exclude .git --delete -arpze ssh /tmp/. jimmy@foo.foo.com:infrastructure/.'
  end

  it "should blow up if it can't connect to the remote node" do
    node = stub('node')
    node.stub!(:dns_name).and_return('com.foo.foo')
    node.stub!(:username).and_return('jimmy')
    node.should_receive(:ssh)

    lambda {
      Skewer::Source.new('/tmp').rsync(node)
    }.should raise_exception RuntimeError
  end
end
