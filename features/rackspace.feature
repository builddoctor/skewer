Feature: provisioning a node on Rackspace
  In order to run my puppet code on a new Rackspace machine
  As someone who wants to deploy something to the machine
  I want to run the provision command

  @announce-stdout
  @announce-stderr
  Scenario: config in local file
    Given I have puppet code in "/tmp/skewer_test_code"
    And a file named ".skewer.json" with:
    """
    {
    "puppet_repo":"/tmp/skewer_test_code",
    "flavor_id":"1",
    "image_id":"112"
    }
    """
    When I run `./bin/skewer provision --cloud rackspace --role foobar --image 112`
    Then the stdout should contain "Evaluating cloud rackspace"
    And the stdout should contain "Launching a Rackspace node"

  @announce-stdout
  @announce-stderr
  Scenario: Build a machine with a specific flavor (RAM size)
    Given I run `./bin/skewer provision --cloud rackspace --role foobar --image 112 --flavor 3`
    Then the stdout should contain "Evaluating cloud rackspace"
    And the stdout should contain "Launching a Rackspace node"
