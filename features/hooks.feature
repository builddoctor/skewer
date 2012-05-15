Feature: Hooks
  In order to integrate Skewer with other processes
  As a user
  I want it to execute a command when it's finished

  Scenario: accept hook on CLI
    Given a file named "/tmp/skewer_hook" with:
    """
    #!/bin/bash
    echo $1 > /tmp/skewer_hook_result
    """
    And I run `chmod +x /tmp/skewer_hook`
    When I run `./bin/skewer --hook=/tmp/skewer_hook provision --cloud=stub --image=foo --role=bar`
    Then the file "/tmp/skewer_hook_result" should exist

  @cloud
  Scenario: run cucumber on completion
    Given I have puppet code in "/tmp/skewer_test_code"
    When I run `./bin/skewer provision --cloud=ec2 --role=apache --image=ami-5c9b4935  --key=testytesty  --puppetcode=/tmp/skewer_test_code  --features=hook-test/features`
    Then the exit status should be 0
    And the stdout should contain "Puppet run succeeded"

  @cloud
  Scenario: failed cucumber should fail the run
    Given I have puppet code in "/tmp/skewer_test_code"
    When I run `./bin/skewer provision --cloud=stub --role=foobar --image=ami-5c9b4935  --key=testytesty  --puppetcode=/tmp/skewer_test_code  --features=hook-test/features`
    Then the exit status should not be 0

