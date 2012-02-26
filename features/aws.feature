Feature: provisioning a node on AWS
  In order to run my puppet code on a new AWS machine
  As someone who wants to deploy something to the machine
  I want to run the provision command

@announce-stdout
@announce-stderr
@wip
Scenario: Roll out AWS node and configure it
  Given I have puppet code in "/tmp/skewer_test_code"
  And a file named ".skewer.json" with:
"""
{"puppet_repo": "/tmp/skewer_test_code", "key_name":  "$AWS_KEY"}
"""
  When I run `./bin/provision --cloud ec2 --role foobar --image ami-5c9b4935`
  Then the stdout should contain "Using Puppet Code from /tmp/skewer_test_code"
