@wip
Feature: Vendor Login to certify application and complete business ownership information

  @vendorbusinessownsership @wip
  Scenario: 1 Login into the certify application and complete below sections
    Given the "Vendor User1" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Business Ownership Details"

  @vendorbusinessownsership @wip
  Scenario: 2 Login into the certify application and complete below sections
    Given the "Vendor User2" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Business Ownership with no LLC Details"

  @vendorbusinessownsership @wip
  Scenario: 3 Login into the certify application and complete below sections
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Business Ownership with LLC Details"


  @example-release
  Scenario: 4 Login into the certify application and complete below sections
    Given the "Vendor User2" logged into the certify application
    And the vendor completes the "Eligibility Information with size"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Business Ownership with no LLC Details"
