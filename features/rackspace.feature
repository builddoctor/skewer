Feature: provisioning a node on Rackspace
  In order to run my puppet code on a new Rackspace machine
  As someone who wants to deploy something to the machine
  I want to run the provision command


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
    When I run `./bin/skewer provision --cloud rackspace --role foobar --image 112 --region lon`
    Then the stdout should contain "Evaluating cloud rackspace"
    And the stdout should contain "Launching a Rackspace node"
    And the exit status should be 0


  Scenario: Build a machine with a specific flavor (RAM size)
    Given I run `./bin/skewer provision --cloud rackspace --role foobar --image 112 --flavor 3  --puppetcode /tmp/skewer_test_code --region lon`
    Then the stdout should contain "Evaluating cloud rackspace"
    And the stdout should contain "Launching a Rackspace node"
    And the exit status should be 0


  Scenario: Build a machine with a symbolic image ID
    Given I run `./bin/skewer provision --cloud rackspace --role foobar --image ubuntu1104 --flavor 2 --puppetcode /tmp/skewer_test_code --region lon`
    Then the stdout should contain "Evaluating cloud rackspace"
    And the stdout should contain "Launching a Rackspace node"
    And the exit status should be 0
