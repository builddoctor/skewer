require 'puppet_node'
require 'skewer_config'

describe Skewer::PuppetNode do
  it "should have a default nodes block" do
    Skewer::PuppetNode.new.to_s.should match /node default/
    Skewer::PuppetNode.new.to_s.should match /include noop/
  end

  it "should render a node name with a class" do
    pn = Skewer::PuppetNode.new({ :foobar => "cafefoobar::install" })
    pn.to_s.should match /node foobar \{/
    pn.to_s.should match /include cafefoobar::install/
    pn.to_s.should match /\}/
  end

  it "should know about the puppet directory" do
    nodes = {"shoopdoop" => "foopidoop"}
    config = Skewer::Config.instance
    pn = Skewer::PuppetNode.new(nodes)
    pn.puppet_repo.should == config.get(:puppet_repo)
  end

  it "should allow you to pass in a role on the fly"  do
    FileUtils.mkdir_p('target/manifests')
    Skewer::Config.instance.set(:puppet_repo, 'target')
    pn = Skewer::PuppetNode.new({:default => :foobar})
    pn.render
    File.read('target/manifests/nodes.pp').should match(/foobar/)
  end
end
