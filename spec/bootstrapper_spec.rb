require 'bootstrapper'
describe Bootstrapper do 
  it "should copy the rubygems profile.d script over" do
    node = mock('node')
    node.should_receive(:scp).with('./lib/../assets/oberon.sh', '/var/tmp/.')
    node.should_receive(:ssh).with('sudo bash /var/tmp/oberon.sh')
    Bootstrapper.new(node).execute('oberon.sh')
  end

  it "should install rubygems on the remote machine" do 
    node = mock('node')
    node.should_receive(:ssh).with('. /etc/profile.d/rubygems.sh && cd infrastructure && bundle install')
    Bootstrapper.new(node).install_gems
  end

end
