Feature: provisioning a node
  In order to run my puppet code for the first time
  As a someone who wants to deploy something to the machine
  I want to run the provision command

@aruba_timeout_seconds(3)
Scenario: run the command without args
  When I run `./bin/provision`
  Then the exit status should not be 0

@announce-stdout
@announce-stderr
Scenario: pass in a cloud image and role
  When I run `./bin/provision --cloud vagrant --image foo --role foo`
  Then the exit status should be 0
