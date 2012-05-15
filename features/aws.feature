Feature: provisioning a node on AWS
  In order to run my puppet code on a new AWS machine
  As someone who wants to deploy something to the machine
  I want to run the provision command

  @announce-stdout
  @announce-stderr

  @cloud
  Scenario: Roll out AWS node and configure it
    Given I have puppet code in "/tmp/skewer_test_code"
    And a file named ".skewer.json" with:
    """
{"puppet_repo": "/tmp/skewer_test_code" }
"""
    When I run `./bin/skewer provision --cloud=ec2 --role=foobar --image=ami-5c9b4935  --key=testytesty`
    Then the exit status should be 0
    And the stdout should contain "Puppet run succeeded"


  @cloud
  Scenario: Roll out AWS node and configure it without a JSON file
    Given I have puppet code in "/tmp/skewer_test_code"
    When I run `./bin/skewer provision --cloud=ec2 --role foobar --image=ami-5c9b4935  --key=testytesty --puppetcode=/tmp/skewer_test_code`
    Then the exit status should be 0
    And the stdout should contain "Puppet run succeeded"


  @announce-stdout
  @announce-stderr
  @cloud
  @wip
  Scenario: Roll out AWS node with a specific region
    Given I have puppet code in "/tmp/skewer_test_code"
    When I run `./bin/skewer provision --cloud=ec2 --role=foobar --image=ami-f6340182 --region=eu-west-1 --key=testytesty --puppetcode=/tmp/skewer_test_code`
    Then the exit status should be 0
    And the stdout should contain "Puppet run succeeded"

  @cloud
  Scenario: Roll out AWS node with a specific size
    Given I have puppet code in "/tmp/skewer_test_code"
    And a file named ".skewer.json" with:
    """
{"puppet_repo": "/tmp/skewer_test_code" }
"""
    When I run `./bin/skewer provision --cloud=ec2 --role=foobar --image=ami-5c9b4935 --flavor=m1.small  --key=testytesty`
    Then the stdout should contain "Puppet run succeeded"
