Feature: Information about all of the smoke tests for certify application

  @smoke
  Scenario: 1 Login into the certify application and submit individual 8a application with fill
    Given the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "Vendor Admin Contributor autofill"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Unassigned view for CODS Supervisors of" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst completes screening of" the initial eight-a certify application
    And the "analyst completes processing and Make recommendation of" the initial eight-a certify application
    And the "Supervisor" logged into the certify application
    And the "supervisor completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ Program" logged into the certify application
    And the "supervisor hq program completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ AA Program" logged into the certify application
    When the "supervisor hq aa completes Make determination of" the initial eight-a certify application
    Then the "Vendor User gets status certified for" the initial eight-a certify application


  @smoke
  Scenario: 2 Login into the certify application and complete annual review/retain for 8a application with fill
    Given the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "Vendor Admin Contributor autofill"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Supervisor assigns district office for" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst completes screening of" the initial eight-a certify application
    And the "analyst completes processing and Make recommendation of" the initial eight-a certify application
    And the "Supervisor" logged into the certify application
    And the "supervisor completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ Program" logged into the certify application
    And the "supervisor hq program completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ AA Program" logged into the certify application
    And the "supervisor hq aa completes Make determination of" the initial eight-a certify application
    And the "Vendor User gets status certified for" the initial eight-a certify application
    And the vendor completes the "method to create annual review"
    And the vendor completes information related to "eight-a annual review with autofill"
    And the vendor completes information related to "eight-a contributor annual review with autofill"
    And the "District Supervisor" logged into the certify application
    And the "Unassigned view for District Supervisor of" the annual review flow
    And the "District Supervisor assigns" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst completes screening and processing of" the annual review flow
    And the "District Analyst verifies the documents of" the annual review flow
    When the "District Analyst completes the Retain Firm for" the annual review flow
#    Then the "Vendor User gets the final status of" the annual review flow

  @smoke
  Scenario: 3 Login into the certify application and complete annual review/intent to terminate for 8a application with fill
    Given the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "Vendor Admin Contributor autofill"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Supervisor assigns district office for" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst completes screening of" the initial eight-a certify application
    And the "analyst completes processing and Make recommendation of" the initial eight-a certify application
    And the "Supervisor" logged into the certify application
    And the "supervisor completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ Program" logged into the certify application
    And the "supervisor hq program completes Make recommendation of" the initial eight-a certify application
    And the "Supervisor HQ AA Program" logged into the certify application
    And the "supervisor hq aa completes Make determination of" the initial eight-a certify application
    And the "Vendor User gets status certified for" the initial eight-a certify application
    And the vendor completes the "method to create annual review"
    And the vendor completes information related to "eight-a annual review with autofill"
    And the vendor completes information related to "eight-a contributor annual review with autofill"
    And the "District Supervisor" logged into the certify application
    And the "Unassigned view for District Supervisor of" the annual review flow
    And the "District Supervisor assigns" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst completes screening and processing of" the annual review flow
    And the "District Analyst verifies the documents of" the annual review flow
    When the "District Analyst completes the Send Letter of Intent to Terminate for" the annual review flow
#    Then the "Vendor User gets the final status of" the annual review flow



