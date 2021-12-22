@wip
Feature: Vendor Login to certify application and complete basic eligibility information

  @vendoreligibility 
  Scenario: 4 Login into the certify application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    Then the profile for the "Vendor User" is displayed


  @vendoreligibility  @wip
  Scenario: 4 Login into the certify application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information with size"
    Then the profile for the "Vendor User" is displayed

