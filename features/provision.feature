Feature: provisioning a node
  In order to run my puppet code for the first time
  As a someone who wants to deploy something to the machine
  I want to run the provision command

@puts
Scenario: run the command without args
  When I run `./bin/provision`
  Then the exit status should not be 0

@announce-stdout
@announce-stderr
Scenario: pass in a cloud image and role
  When I run `./bin/provision --cloud stub --image foo --role foo`
  Then the exit status should be 0

@announce-stdout
@announce-stderr
Scenario: config in local file
  Given I have puppet code in "/tmp/skewer_test_code"
  And a file named ".skewer.json" with:
  """
  {"puppet_repo":"/tmp/skewer_test_code"}
  """
  When I run `./bin/provision --cloud stub --role foobar --image ami-deadbeef`
  Then the stdout should contain "Using Puppet Code from /tmp/skewer_test_code"

@announce-stdout
@announce-stderr
Scenario: generated node file
   Given I have puppet code in "/tmp/more_skewer_test_code"
   And a file named ".skewer.json" with:
  """
  {"puppet_repo":"/tmp/skewer_test_code"}
  """
   When I run `./bin/provision --cloud stub --role foobar --image ami-deadbeef`
   Then the file "/tmp/more_skewer_test_code/manifests/nodes.pp" should exist
