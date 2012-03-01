Feature: updating a node
  In order to run my puppet code again
  As a someone who wants to update config on the machine
  I want to run the update command

Scenario: run the command without args
  When I run `./bin/update`
  Then the exit status should not be 0

@announce-stdout @announce-stderr
Scenario: pass in a hostname user and role and no-op
  Given I have access to the internet
  And I have puppet code in "/tmp/skewer_test_code"
  When I run `/bin/update --host default --user vagrant --role foobar --puppetcode /tmp/skewer_test_code/ --noop`
  Then the exit status should be 0
  And the stdout should contain "Using Puppet Code from /tmp/skewer_test_code/"
  And the stdout should contain "notice: Finished catalog run in"

