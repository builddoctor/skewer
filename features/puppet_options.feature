Feature: Puppet Options
  In order to run Puppet in a way that suits me
  As a systems administrator
  I want to pass options to puppet

  @announce-stdout
  @announce-stderr
  Scenario: Set Manifest Path
    Given I have puppet code in "/tmp/more_skewer_test_code"
    And a file named ".skewer.json" with:
    """
  {"puppet_repo":"/tmp/skewer_test_code"}
  """
    When I run `./bin/skewer --manifestpath=foo/bar.pp provision --cloud=stub --role=foobar --image=ami-deadbeef`
    Then the stdout should contain "Using manifest foo/bar.pp"

  @announce-stdout
  @announce-stderr
  Scenario: Set Manifest Path
    Given I have puppet code in "/tmp/more_skewer_test_code"
    And a file named ".skewer.json" with:
    """
  {"puppet_repo":"/tmp/skewer_test_code"}
  """
    When I run `./bin/skewer provision --cloud=stub --role=foobar --image=ami-deadbeef`
    Then the stdout should contain "Using manifest manifests/site.pp"