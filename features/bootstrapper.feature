Feature: valid bash bootstrap code
  In order to run the tool
  As a user
  I want the bootstrap code to work

Scenario: valid bash file
  When I run `bash -nx assets/rubygems.sh`
  Then the exit status should be 0
  
Scenario: only indents should be tabs
  When a file named "assets/rubygems.sh" should exist
  Then the file "assets/rubygems.sh" shouldnt match "^ +"
  And  the file "assets/rubygems.sh" should match "^\t"
  