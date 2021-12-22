@wip
Feature: Vendor Login to certify application and complete all sections and submit 8a application

  @8a_application @regression
  Scenario: 1 Login into the certify application and submit individual 8a application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Business Ownership Details"
    And  the vendor completes information related to "Individual Contributor Creation"
    And  the vendor completes information related to "Individual Contributors Details"
    When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review

  @8a_application @regression @APP-2760 @APP-2671 @APP-2672 @APP-2673 @APP-2674 @APP-2679 @wip
  Scenario: 2 Submission of 8a application with three contributors
    Given the "REST Administrator" logged into the certify application
    And the "contributors are deleted" as registered from the Mailinator site
    And the "Vendor User3" logged into the certify application
    And the vendor completes the "Eligibility Information"
   # And the vendor completes information related to "Character Details"
   # And the vendor completes information related to "Control Details"
   # And the vendor completes information related to "Potential for Success Details"
   # And the vendor completes information related to "Business Ownership Details"
   # And the vendor completes information related to "Individual Contributor Creation"
   # And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "Multiple Contributors Creation"
    And the "Contributor A" is on Mailinator site
    And the users verifies his "Login" or "Sign Up" credentials
    And the user confirms his "SBA Contributor A registration" in the login inbox messages
    And the user confirms his "SBA Contributor B registration" in the login inbox messages
    And the user confirms his "SBA Contributor C registration" in the login inbox messages
    And the "Contributor A" logged into the certify application
    And the vendor completes information related to "Contributor A Details"
    And the "Contributor B" logged into the certify application
    And the vendor completes information related to "Contributor B Details"
    And  the "Contributor C" logged into the certify application
    And  the vendor completes information related to "Contributor C Details"
   # And  the "Vendor User3" logged into the certify application
   # When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review

  @8a_application @APP-2760 @APP-2671 @APP-2672 @APP-2673 @APP-2674 @APP-2679 @wip
  Scenario: 3 Submission of 8a application with two contributors
    Given the "REST Administrator" logged into the certify application
    And the "contributors are deleted" as registered from the Mailinator site
    And the "Vendor User2" logged into the certify application
    And the vendor completes the "Eligibility Information"
    And the vendor completes information related to "Character Details"
    And the vendor completes information related to "Control Details"
    And the vendor completes information related to "Potential for Success Details"
    And the vendor completes information related to "Business Ownership Details"
    And the vendor completes information related to "Individual Contributor Creation"
    And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "Two Contributors Creation"
    And the "Contributor A2" is on Mailinator site
    And the users verifies his "Login" or "Sign Up" credentials
    And the user confirms his "SBA Contributor A2 registration" in the login inbox messages
    And the user confirms his "SBA Contributor B2 registration" in the login inbox messages
    And the "Contributor A2" logged into the certify application
    And the vendor completes information related to "Contributor A2 Details"
    And  the "Contributor B2" logged into the certify application
    And  the vendor completes information related to "Contributor B2 Details"
   # And  the "Vendor User2" logged into the certify application
   # When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review


  @8a_application @APP-2760 @APP-2671 @APP-2672 @APP-2673 @APP-2674 @APP-2679 @wip
  Scenario: 4 Submission of 8a application with one contributors
    Given the "REST Administrator" logged into the certify application
    And the "contributors are deleted" as registered from the Mailinator site
    And the "Vendor User1" logged into the certify application
    And the vendor completes the "Eligibility Information"
   # And the vendor completes information related to "Character Details"
   # And the vendor completes information related to "Control Details"
   # And the vendor completes information related to "Potential for Success Details"
   # And the vendor completes information related to "Business Ownership Details"
   # And the vendor completes information related to "Individual Contributor Creation"
   # And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "One Contributor Creation"
    And the "Contributor A1" is on Mailinator site
    And the users verifies his "Login" or "Sign Up" credentials
    And the user confirms his "SBA Contributor A1 registration" in the login inbox messages
    And the "Contributor A1" logged into the certify application
    And the vendor completes information related to "Contributor A1 Details"
   # And  the "Vendor User1" logged into the certify application
   # When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review

  @8a_application @mailinator @wip
  Scenario: 2 Login into the mailinator and signup or login
    Given the "Contributor A" is on Mailinator site
    When the users verifies his "Login" or "Sign Up" credentials
    Then the user confirms his "credentials" in the login inbox messages


  @8a_application @8a_multicontributor @mailinator @wip
  Scenario: 3a Login into the certify application and add multiple contributor for 8a application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Multiple Contributors Creation"
    And the "Contributor A" is on Mailinator site
    When the users verifies his "Login" or "Sign Up" credentials
    Then the user confirms his "Contributor A registration" in the login inbox messages
    Then the user confirms his "Contributor B registration" in the login inbox messages
    Then the user confirms his "Contributor C registration" in the login inbox messages


 @8a_application @8a_multicontributor @mailinator @wip
  Scenario: 3b Login into the certify application and add multiple contributor for 8a application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Multiple Contributors Creation"
    And the "Contributor A" is on Mailinator site
    When the users verifies his "Login" or "Sign Up" credentials
 #   Then the user confirms his "SBA Contributor A registration" in the login inbox messages
 #   Then the user confirms his "SBA Contributor B registration" in the login inbox messages
 #   Then the user confirms his "SBA Contributor C registration" in the login inbox messages


  @8a_application @8a_multicontributor @mailinator @wip
  Scenario: 4 Login into the certify application and create multiple contributors and deletes them
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "application deletion"
    And the "Contributor A" is on Mailinator site
    And the users verifies his "Login" or "Sign Up" credentials
    And the user confirms his "Contributor A removal notice" in the login inbox messages
    And the user confirms his "Contributor B removal notice" in the login inbox messages
    And the user confirms his "Contributor C removal notice" in the login inbox messages
    And the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Multiple Contributors creation and deletion"
    And the "Contributor A" is on Mailinator site
    When the users verifies his "Login" or "Sign Up" credentials
    Then the user confirms his "Contributor A removal notice" in the login inbox messages
    Then the user confirms his "Contributor A removal notice" in the login inbox messages
    Then the user confirms his "Contributor A removal notice" in the login inbox messages

  @8a_application @8a_multicontributor @wip
  Scenario: 5 Login into the certify application and submit multiple contributor 8a application
    Given the "Vendor User" logged into the certify application
    And  the vendor completes the "Eligibility Information"
    And  the vendor completes information related to "Character Details"
    And  the vendor completes information related to "Control Details"
    And  the vendor completes information related to "Potential for Success Details"
    And  the vendor completes information related to "Business Ownership Details"
    And  the vendor completes information related to "Individual Contributor Creation"
    And  the vendor completes information related to "Individual Contributors Details"
    And  the vendor completes information related to "Multiple Contributors Creation"
    
   
   ## Notes contributor registration is hindered by security image question ##

@8a_application @8a_multicontributor @wip
  Scenario: 4 Login into the certify application and submit multiple contributor 8a application
    Given  the "Contributor A" logged into the certify application
    And  the vendor completes information related to "Contributor A Details"
   # And  the "Contributor B" logged into the certify application
   # And  the vendor completes information related to "Contributor B Details"
   # And  the "Contributor C" logged into the certify application
   # And  the vendor completes information related to "Contributor C Details"
   # And  the "Vendor User" logged into the certify application
   # When the vendor completes information related to "Review and Sign the 8a application"
   # Then  the vendor "8a application" is received by sba portal for review