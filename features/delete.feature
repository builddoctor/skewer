Feature: updating a node
  In order to delete a node
  As a someone who knows the cloud and host address
  I want to run the delete command

@announce-stdout @announce-stderr
Scenario: run the command with bad input
  When I run `./bin/skewer delete --cloud ec2 --host bleh --key ~/.ssh/testytest.pem`
  Then the stderr should contain "bleh not found"
  And the exit status should not be 0

@announce-stdout @announce-stderr
Scenario: run the command with bad input
  When I run `./bin/skewer delete --cloud ec2 --host bleh --key ~/.ssh/testytest.pem`
  Then the stderr should contain "bleh not found"
  And the exit status should not be 0

@wip @announce-stdout @announce-stderr
Scenario: create a new Rackspace server and delete it
  Given I create a new Rackspace server
  When I delete the new Rackspace server I created
  Then the output should say that the Rackspace server was deleted
