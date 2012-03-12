Feature: help output for the skewer command-line tool
  In order to get sufficient feedback
  As someone who wants to use skewer
  When I do something wrong or provide the help option
  I want the help messages to appear

  Scenario: run the command without arguments
    When I run `./bin/skewer`
    Then the output should contain:
    """
    Usage: skewer COMMAND [options]

    The available skewer commands are:
       provision  spawn a new VM via a cloud system and provision it with puppet code
       update     update the puppet code on a machine that you've already provisioned
    """
    And the exit status should not be 0

  Scenario: run the command with help option
    When I run `./bin/skewer --help`
    Then the output should contain:
    """
    Usage: skewer COMMAND [options]

    The available skewer commands are:
       provision  spawn a new VM via a cloud system and provision it with puppet code
       update     update the puppet code on a machine that you've already provisioned
    """
    And the exit status should not be 0

  Scenario: run the provision command without arguments
    When I run `./bin/skewer provision`
    Then the output should contain:
    """
    Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>
    """
    And the exit status should not be 0

  Scenario: run the provision command with help arguments
    When I run `./bin/skewer provision --help`
    Then the output should contain:
    """
    Usage: skewer provision --cloud <which cloud>  --image <AWS image> --role <puppet role class>
    """
    And the exit status should not be 0

  Scenario: run the update command without arguments
    When I run `./bin/skewer update`
    Then the output should contain:
    """
    Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>
    """
    And the exit status should not be 0

  Scenario: run the update command with help arguments
    When I run `./bin/skewer update --help`
    Then the output should contain:
    """
    Usage: skewer update --host <host> --user <user with sudo rights> --role <puppet role class>
    """
    And the exit status should not be 0
