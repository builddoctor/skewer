require 'bootstrapper'
describe Bootstrapper do 
  it "should barf if the file doesn't exist" do
    lambda {Bootstrapper.new(nil).execute('oberon.sh')}.should raise_exception RuntimeError
  end

  it "should copy the rubygems profile.d script over" do
    node = mock('node')
    node.should_receive(:scp).with('./lib/../assets/rubygems.sh', '/var/tmp/.')
    node.should_receive(:ssh).with('sudo bash /var/tmp/rubygems.sh')
    Bootstrapper.new(node).execute('rubygems.sh')
  end

  it "should install rubygems on the remote machine" do 
    node = mock('node')
    node.should_receive(:ssh).with('. /etc/profile.d/rubygems.sh && cd infrastructure && bundle install')
    Bootstrapper.new(node).install_gems
  end

end
