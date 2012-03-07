Feature: Hooks
  In order to integrate Skewer with other processes
  As a user
  I want it to execute a command when it's finihsed

Scenario: accept hook on CLI
  Given a file named "/tmp/skewer_hook" with:
  """
  #!/bin/bash
  echo $1 > /tmp/skewer_hook_result
  """
  And I run "chmod +x /tmp/skewer_hook"
  When I run `./bin/provision --cloud stub --image foo --role bar --hook /tmp/skewer_hook`
  Then the file "/tmp/skewer_hook_result" should exist

