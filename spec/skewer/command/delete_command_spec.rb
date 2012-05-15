require "rspec"
require 'skewer/command/delete'

describe "Delete" do

  it "should take real hostname" do
    Skewer::Command::Delete.new({},{:cloud => :foo}, ['foo.bar.com']).valid?[0].should be_true
  end

  it "should reject bogus hostname" do
    Skewer::Command::Delete.new({},{:cloud => :foo}, ['foo']).valid?[0].should be_false
  end

  it "should barf if you give it more than one arg" do
    Skewer::Command::Delete.new({},{:cloud => :foo}, ['foo.bar.com', 'foo.foo']).valid?[0].should be_false
  end

  it "should accept if you give it one arg" do
    Skewer::Command::Delete.new({},{:cloud => :foo}, ['foo.bar.com']).valid?[0].should be_true
  end

  it "should insist on a region" do
    Skewer::Command::Delete.new({},{:cloud => :foo,:region => 'eu-west-1'}, ['foo.bar.com']).valid?[0].should be_true
  end

  it "should insist on a cloud" do
    Skewer::Command::Delete.new({},{}, ['foo.bar.com']).valid?[0].should be_false
  end

  # check for mock and noop!
  # test AWS and Rackspace clouds on delete
  # test for optional region?
  # fail on puppetcode, hook, and features

end