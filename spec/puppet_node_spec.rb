require 'puppet_node'
describe PuppetNode do 
  it "should have a default nodes block" do 
    PuppetNode.new.to_s.should match /node default/ 
    PuppetNode.new.to_s.should match /include noop/ 
  end

  it "should render a node name with a class" do
    pn = PuppetNode.new
    pn.nodes = { :foobar => "cafefoobar::install" }
    pn.to_s.should match /node foobar \{/
    pn.to_s.should match /include cafefoobar::install/
    pn.to_s.should match /\}/
  end

  it "should accept a json hash of external node definitions" do 
    json = '{"poohbah": "shoopidoop" }'
    pn = PuppetNode.new(json)
    pn.to_s.should match /shoopidoop/
    pn.to_s.should match /noop/
  end

end
