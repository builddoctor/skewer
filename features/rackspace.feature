Feature: provisioning a node on Rackspace
  In order to run my puppet code on a new Rackspace machine
  As someone who wants to deploy something to the machine
  I want to run the provision command

@announce-stdout
@announce-stderr
@wip
Scenario: config in local file
  Given I have puppet code in "/tmp/skewer_test_code"
  And I have a configuration file
  When I run `./bin/provision --cloud rackspace --role foobar --image 58`
  Then the stdout should contain "Using Puppet Code from /tmp/skewer_test_code"
