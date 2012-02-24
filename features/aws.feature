Feature: provisioning a node on AWS
  In order to run my puppet code on a new AWS machine
  As a someone who wants to deploy something to the machine
  I want to run the provision command

@announce-stdout
@announce-stderr
@wip

  # This depends on access to an SSHkey.
  # Probably easiest to create a new key, use it, and delete it.
Scenario: config in local file
  Given I have puppet code in "/tmp/skewer_test_code"
  And I have a configuration file
  When I run `./bin/provision --cloud ec2 --role foobar --image ami-5c9b4935`
  Then the stdout should contain "Using Puppet Code from /tmp/skewer_test_code"