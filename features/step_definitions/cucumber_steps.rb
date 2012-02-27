Before do
  config_file = File.join(File.dirname(__FILE__), '../..', '.skewer.json')
  puts "Checking for #{config_file}"
  if File.exists?(config_file)
    puts "Removing #{config_file}"
    FileUtils.rm_f(config_file)
  end
end

Given /^I have puppet code in "([^"]*)"$/ do |dir|

  puppet_code_source = File.join(File.dirname(__FILE__), '../support/puppetcode')
  puts "Copying #{puppet_code_source} to #{dir}"
  FileUtils.cp_r(puppet_code_source, dir) unless File.exists?(dir)
  @puppet_repo = dir
end


require 'resolv-replace'
require 'ping'

def internet_connection?
  Ping.pingecho "google.com", 1, 80
end


Given /^I have access to the internet$/ do
  internet_connection?.should == true
end

Then /^the file "([^"]*)" should exist$/ do |file|
  File.exists?(file).should == true
end

Then /^the file "([^"]*)" (.*) match "([^"]*)"$/ do |file, condition, expr|
  file_contents = File.read(file)
  if condition == 'should'
    file_contents.should match expr
  else
    file_contents.should_not match expr
  end
end

