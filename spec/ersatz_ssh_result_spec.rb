require 'skewer/ersatz/ssh_result'

describe Skewer::ErsatzSSHResult do
  it "should build out an SSH object" do
    e = Skewer::ErsatzSSHResult.new('cmd', 'stdout', 'status')
    e.nil?.should == false
    e.class.should == Skewer::ErsatzSSHResult
  end

  it "should have attribute accessors" do
    e = Skewer::ErsatzSSHResult.new('cmd', 'stdout', 'status')
    e.command.should == 'cmd'
    e.stdout.should == 'stdout'
    e.status.should == 'status'
  end
end
