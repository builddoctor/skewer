require 'fog'

Given /^I create a new AWS server$/ do
  service = Fog::Compute.new(:provider => 'AWS')
  @dns_name = "IT_BREAKS_FROM_HERE"
  # node = service.servers.bootstrap(:private_key_path => '~/.ssh/id_rsa', :public_key_path => '~/.ssh/id_rsa.pub')
  # node.wait_for { |n| n.ready? }
  # @dns_name = node.dns_name
end

When /^I delete the new AWS server I created$/ do
  name = @dns_name
  # The 2>&1 tells shell to redirect stderr to stdout.
  @out = `./bin/skewer delete --cloud ec2 --host #{name} --key ~/.ssh/testytest.pem 2>&1`
end

Then /^the output should say that the AWS server was deleted$/ do
  name = @dns_name
  @out.should == "#{name} deleted"
end
