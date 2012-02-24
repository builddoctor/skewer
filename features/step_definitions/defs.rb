


Before do
  require 'fileutils'
  @config_file = File.join(ENV['HOME'], '.skewer.json')

  if File.exists?(@config_file)
    backup_timestamp = Date.today.strftime('%Y-%m-%d_%H-%M')
    backup_filename = @config_file + '.' + backup_timestamp
    puts "Backing up your existing Skewer config file to: #{backup_filename}"
    FileUtils.cp(@config_file, backup_filename)
  end
end

After do
  #TODO - kill the duplication
  @config_file = File.join(ENV['HOME'], '.skewer.json')
  FileUtils.rm_rf(@config_file)
end

Given /^I have a configuration file$/ do
  File.open(@config_file, 'w+') { |f| f << "{\"puppet_repo\": \"#{@puppet_repo}\"}" }
  puts "I JUST MADE A CONFIG FILE HERE: #{@config_file}"
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

