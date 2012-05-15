Feature: Configuration
  In order to tell Skewer what I am doing
  As a user
  I want it to accept a config file 

Scenario: read config from project directory
  Given a file named ".skewer.json" with:
  """
  {"puppet_repo":"/foo/bar/baz"}
  """
  When I run `./bin/skewer provision --cloud=stub --image=foo --role=bar`
  Then the stdout should contain "Using Puppet Code from /foo/bar/baz"

