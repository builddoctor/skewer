Feature: puppet install strategies
  In order to install Puppet in a way that suits me
  As a someone who wants to deploy something to the machine
  I want to choose a strategy to do so

  @announce-stdout
  @announce-stderr
  Scenario: Defaults strategy of Bundler
    Given I have puppet code in "/tmp/more_skewer_test_code"
    And a file named ".skewer.json" with:
    """
  {"puppet_repo":"/tmp/skewer_test_code"}
  """
    When I run `./bin/skewer provision --cloud=stub --role=foobar --image=ami-deadbeef`
    Then the stdout should contain "Deploying Puppet via Bundler"

  Scenario: Explicit invocation of Bundler
    Given I have puppet code in "/tmp/more_skewer_test_code"
    And a file named ".skewer.json" with:
    """
    {"puppet_repo":"/tmp/skewer_test_code"}
    """
    When I run `./bin/skewer --strategy=bundler provision --cloud=stub --role=foobar --image=ami-deadbeef`
    Then the stdout should contain "Deploying Puppet via Bundler"

  Scenario: Explicit invocation of Debian
      Given I have puppet code in "/tmp/more_skewer_test_code"
      And a file named ".skewer.json" with:
      """
      {"puppet_repo":"/tmp/skewer_test_code"}
      """
      When I run `./bin/skewer --strategy=debian provision --cloud=stub --role=foobar --image=ami-deadbeef`
      Then the stdout should contain "Deploying Puppet via Debian"
