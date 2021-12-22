Feature: Login to certify application

  @login @cucumber-int
  Scenario: 1 Login into the certify application
    Given the "Vendor User" logged into the certify application
    Then the profile for the "Vendor User" is displayed

  @login
  Scenario: 2 Login into the certify application
    Given the "Supervisor" logged into the certify application
    Then the profile for the "Supervisor" is displayed

  @login
  Scenario: 3 Login into the certify application
    Given the "Analyst" logged into the certify application
    Then the profile for the "Analyst" is displayed
