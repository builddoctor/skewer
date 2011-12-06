require 'lib/ersatz/ersatz_node.rb'
describe ErsatzNode do 
  it "should have attributes" do 
    node = ErsatzNode.new('mehostname','meuser')
    node.username.should == 'meuser'
    node.dns_name.should == 'mehostname'
  end
end
