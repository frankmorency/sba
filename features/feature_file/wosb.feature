Feature: WOSB Smoke Tests

  @wosb @smoke @wip
  Scenario: 1 Login into the certify application and submit WOSB application
    Given the "Vendor User1" logged into the certify application
    And the vendor starts an application for the "WOSB" program
    And the vendor completes the simple "WOSB" application
    Then the vendor gets self-certified in "WOSB" program

  @wosb @smoke @wip
  Scenario: 2 As an Analyst in the WOSB program I can perform my job functions
    Given the "WOSB Analyst" logged into the certify application
    Then view "WOSB" cases pre-filtered on All Cases Page
    Then search for a business by its DUNS number and view its applications






