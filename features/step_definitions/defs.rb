
def safely_write_config_file
  require 'fileutils'
  backup_config_file = nil
@config_file = File.join(ENV['HOME'], '.skewer.json')

  # do they have a skewer config file?

  if File.exists?(@config_file)
    # copy it if they do
    backup_config_file = Date.today.strftime('%Y-%m-%d')
    FileUtils.cp(@config_file, backup_config_file)
  end

  # write out the new one
  File.open(@config_file, 'w+') { |f| f << "{\"puppet_repo\": \"#{@puppet_repo}\"}" }
end

After do
  #TODO - kill the duplication
  @config_file = File.join(ENV['HOME'], '.skewer.json')
  FileUtils.rm_rf(@config_file)
end

Given /^I have a configuration file$/ do
  safely_write_config_file
end

Given /^I have puppet code in "([^"]*)"$/ do |dir|
  FileUtils.mkdir_p(File.join(dir, 'manifests'))
  @puppet_repo = dir
end

Given /^I have access to the internet$/ do
  system('ping -c 2 google.com').should == true
end

Then /^the file "([^"]*)" should exist$/ do |file|
  File.exists?(file).should == true
end

