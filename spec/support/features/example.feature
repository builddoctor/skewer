Feature: example feature for the Skewer::Cuke spec
  In order to check that Skewer::Cuke fails
  I want to provide a failing cuke feature

  @announce-stdout
  @announce-stderr
  Scenario: Always failing scenario
    Given I run something arbitrary
    Then it should fail
