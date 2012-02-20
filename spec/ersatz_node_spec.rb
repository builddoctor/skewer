require 'lib/ersatz/ersatz_node.rb'

describe Skewer::ErsatzNode do 
  it "should have attributes" do 
    node = Skewer::ErsatzNode.new('mehostname','meuser')
    node.username.should == 'meuser'
    node.dns_name.should == 'mehostname'
  end
end
