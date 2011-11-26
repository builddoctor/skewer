require 'puppet'
describe Puppet do

 before(:each) do
    @puppet = Puppet.new
    @root = File.expand_path File.join(File.dirname(__FILE__), "..")
    @prefix = "cd infrastructure && /var/lib/gems/1.8/bin/bundle exec puppet apply etc/puppet/manifests/site.pp"
    @sudo_prefix = "cd infrastructure && sudo /var/lib/gems/1.8/bin/bundle exec puppet apply etc/puppet/manifests/site.pp"
  end

  it "should sudo when connecting as root" do
    @puppet.command_string('goober', {}).should == "#{@sudo_prefix} --modulepath etc/puppet/modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
   #bundle exec puppet apply etc/puppet/manifests/site.pp --external_nodes=/root/infrastructure/lib/extnode.rb --node_terminus=exec --modulepath=etc/puppet/modules
  end

  it "should pass a certname if you ask it " do
    @puppet.command_string('goober', {:role => 'graunch'}).should == "#{@sudo_prefix} --certname graunch --modulepath etc/puppet/modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
  end

  it "should not sudo when connecting as root" do
    @puppet.command_string('root', {}).should == "#{@prefix} --modulepath etc/puppet/modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb"
  end

  it "should pass noop when if you pass the option" do
    @puppet.command_string('root', {:noop => true}).should == "#{@prefix} --modulepath etc/puppet/modules --node_terminus=exec --external_nodes=`pwd`/lib/extnode.rb --noop"
  end

  it "should have args for our custom modulepath" do
    @puppet.arguments.should match(/modulepath/)
  end

  it "should have args for our external node configuration" do
    @puppet.arguments.should match(/external_nodes/)
  end

end

