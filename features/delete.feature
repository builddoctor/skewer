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
Scenario: create a new AWS server and delete it
  Given I create a new AWS server
  When I delete the new AWS server I created
  Then the output should say that the AWS server was deleted
  And the exit status should be 0
