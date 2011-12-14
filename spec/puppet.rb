require 'lib/puppet'
describe Puppet do

 before(:each) do
    @puppet = Puppet.new
    @root = File.expand_path File.join(File.dirname(__FILE__), "..")
    @prefix = "cd infrastructure && /var/lib/gems/1.8/bin/bundle exec puppet apply manifests/site.pp"
    @sudo_prefix = "cd infrastructure && sudo /var/lib/gems/1.8/bin/bundle exec puppet apply manifests/site.pp"
  end

  it "should sudo when connecting as root" do
    @puppet.command_string('goober', {}).should == "#{@sudo_prefix} --modulepath modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
  end

  it "should pass a certname if you ask it " do
    @puppet.command_string('goober', {:role => 'graunch'}).should == "#{@sudo_prefix} --certname graunch --modulepath modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
  end

  it "should not sudo when connecting as root" do
    @puppet.command_string('root', {}).should == "#{@prefix} --modulepath modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
  end

  it "should pass noop when if you pass the option" do
    @puppet.command_string('root', {:noop => true}).should == "#{@prefix} --modulepath modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb --noop"
  end

  it "should have args for our custom modulepath" do
    @puppet.arguments.should match(/modulepath/)
  end

  it "should have args for our external node configuration" do
    @puppet.arguments.should match(/external_nodes/)
  end

  it "should blow up if something fails" do 
    node = mock('node')
    result = stub('result')
    result.stub!('status').and_return(1)
    result.stub!('command').and_return('sys-unconfig')
    result.stub!('stdout').and_return('mucho failo')
    node.should_receive(:username).and_return('danmadams')
    #node.should_receive(:dns_name).and_return('shoopfoopdoopy.doop')
    node.should_receive(:ssh).and_return([result])
    lambda { @puppet.run(node, {})  }.should raise_exception RuntimeError
  end

end

