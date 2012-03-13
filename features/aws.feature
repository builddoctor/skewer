Feature: provisioning a node on AWS
  In order to run my puppet code on a new AWS machine
  As someone who wants to deploy something to the machine
  I want to run the provision command

@announce-stdout
@announce-stderr
Scenario: Roll out AWS node and configure it
  Given I have puppet code in "/tmp/skewer_test_code"
  And a file named ".skewer.json" with:
"""
{"puppet_repo": "/tmp/skewer_test_code", "key_name":  "testytesty"}
"""
  When I run `./bin/skewer provision --cloud ec2 --role foobar --image ami-5c9b4935`
  Then the stdout should contain "Puppet run succeeded"

@announce-stdout
@announce-stderr

Scenario: Roll out AWS node and configure it without a JSON file
  Given I have puppet code in "/tmp/skewer_test_code"
  When I run `./bin/skewer provision --cloud ec2 --role foobar --image ami-5c9b4935  --key testytesty --puppetcode /tmp/skewer_test_code`
  Then the stdout should contain "Puppet run succeeded"

Scenario: Roll out AWS node with a specific region
  Given I have puppet code in "/tmp/skewer_test_code"
  And a file named ".skewer.json" with:
"""
{"puppet_repo": "/tmp/skewer_test_code", "key_name":  "testytesty"}
"""
  When I run `./bin/skewer provision --cloud ec2 --role foobar --image ami-f6340182 --region eu-west-1`
  Then the stdout should contain "Puppet run succeeded"
