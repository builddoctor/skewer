Feature: provisioning a node
  In order to run my puppet code for the first time
  As a someone who wants to deploy something to the machine
  I want to run the provision command

@puts
Scenario: run the command without args
  When I run `./bin/provision`
  Then the exit status should not be 0

@puts
Scenario: pass in a cloud image and role
  When I run `./bin/provision --cloud stub --image foo --role foo`
  Then the exit status should be 0

@announce-stdout
@announce-stderr
@wip
Scenario: config in local file
  Given I have a configuration file
  And I have puppet code in "/tmp/skwer_test_codez"
  When I run `./bin/provision --cloud stub --role foobar --image ami-deadbeef`
  Then the stdout should contain "Using Puppet Code from /tmp/skwer_test_codez"

