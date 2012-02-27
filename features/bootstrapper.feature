Feature: valid bash bootstrap code
  In order to run the tool
  As a user
  I want the bootstrap code to work

Scenario: valid file
  When I run `bash -nx assets/rubygems.sh`
  Then the exit status should be 0