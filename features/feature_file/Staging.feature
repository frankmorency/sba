@wip
Feature: Vendor Login to certify application and complete all sections and submit 8a application

  @8a_application @regression @staging
  Scenario: 1 Login into the certify application and submit individual 8a application
    Given the "Staging Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Business Ownership Details"
    And  the vendor completes information related to "Individual Contributor Creation"
    And  the vendor completes information related to "Individual Contributors Details"
  #  When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review

  @8a_application @regression @staging @wip
  Scenario: 1 Submission of 8a application with three contributors
#    Given the "REST Administrator" logged into the certify application
#    And the "contributors are deleted" as registered from the Mailinator site
    And the "Staging Vendor User" logged into the certify application
    And the vendor completes the "Eligibility Information"
    And the vendor completes information related to "Character Details"
    And the vendor completes information related to "Control Details"
    And the vendor completes information related to "Potential for Success Details"
    And the vendor completes information related to "Business Ownership Details"
    And the vendor completes information related to "Individual Contributor Creation"
    And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "Multiple Contributors Creation"
  #  And the "Contributor A" logged into the certify application
  #  And the vendor completes information related to "Contributor A Details"
  #  And the "Contributor B" logged into the certify application
  #  And the vendor completes information related to "Contributor B Details"
  #  And  the "Contributor C" logged into the certify application
   # And  the vendor completes information related to "Contributor C Details"
   # And  the "Vendor User3" logged into the certify application
   # When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review

