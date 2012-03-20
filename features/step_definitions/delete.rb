require 'fog'

Given /^I create a new Rackspace server$/ do
  build = lambda {
    service = Fog::Compute.new(
      :provider => 'Rackspace',
      :rackspace_auth_url => "lon.auth.api.rackspacecloud.com")
    path = File.expand_path '~/.ssh/id_rsa.pub'
    path = File.expand_path '~/.ssh/id_dsa.pub' if not File.exist? path
    key = File.open(path, 'rb').read
    return service.servers.bootstrap({
      :flavor_id => 1,
      :image_id => 112,
      :name => "i-shouldnt-exist",
      :public_key => key})
  }
  @node = build.call
  @ip_address = node.public_ip_address
end

When /^I delete the new Rackspace server I created$/ do
  ip = @ip_address
  # The 2>&1 tells shell to redirect stderr to stdout.
  @out = `./bin/skewer delete --cloud rackspace --host #{ip} 2>&1`
end

Then /^the output should say that the Rackspace server was deleted$/ do
  ip = @ip_address
  match = @out.match("#{ip} deleted")
  match.should_not == nil
  match.class.should == MatchData
end
