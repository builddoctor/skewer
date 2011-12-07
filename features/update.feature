Feature: updating a node
  In order to run my puppet code again
  As a someone who wants to update config on the machine
  I want to run the update command

Scenario: run the command without args
  When I run `./bin/update`
  Then the exit status should not be 0

@announce-stdout @announce-stderr
Scenario: pass in a hostname user and role and 
  When I run `./bin/update --host default --user vagrant --role bar --noop`
  Then the exit status should be 0

