Feature: Information about all of the smoke tests for certify application with more functionalities(Long Execution Times)

  @regression
  Scenario:  1 complete certify 8a application and complete annual review/retain for 8a application with fill
    Given the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "Vendor Admin Contributor autofill"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Supervisor assigns district office for" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst sends 15 day letter (Return to Firm for Revisions) for" the initial eight-a certify application
    And the "Vendor User" logged into the certify application
    And the vendor completes information related to "Review and Sign the 8a application for returned 15 day letter"
    And the "Analyst" logged into the certify application
    And the "analyst completes returned 15 day screening of" the initial eight-a certify application
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
    And the "District Analyst sends a deficiency letter for" the annual review flow
    And the "Vendor User" logged into the certify application
    And the "Vendor User completes the deficiency letter for" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst completes screening and processing of" the annual review flow
    And the "District Analyst verifies the documents of" the annual review flow
    When the "District Analyst completes the Retain Firm for" the annual review flow
 #   Then the "Vendor User gets the final status of" the annual review flow


  @regression
  Scenario:  2 complete certify 8a application and complete annual review/retain for 8a application without fill
    Given the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "Individual Contributor Creation"
    And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Supervisor assigns district office for" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst sends 15 day letter (Return to Firm for Revisions) for" the initial eight-a certify application
    And the "Vendor User" logged into the certify application
    And the vendor completes information related to "Review and Sign the 8a application for returned 15 day letter"
    And the "Analyst" logged into the certify application
    And the "analyst completes returned 15 day screening of" the initial eight-a certify application
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
    And the vendor completes information related to "contributor annual review completion"
    And the "District Supervisor" logged into the certify application
    And the "Unassigned view for District Supervisor of" the annual review flow
    And the "District Supervisor assigns" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst sends a deficiency letter for" the annual review flow
    And the "Vendor User" logged into the certify application
    And the "Vendor User completes the deficiency letter for" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst completes screening and processing of" the annual review flow
    And the "District Analyst verifies the documents of" the annual review flow
    When the "District Analyst completes the Retain Firm for" the annual review flow
 #   Then the "Vendor User gets the final status of" the annual review flow


  @reg
  Scenario:  3 complete certify 8a application with two contributor and complete annual review/retain for 8a without fill
    Given the "Gmail User" logged into the gmail account
    And the "Vendor User" logged into the certify application
    And the vendor completes the "8a initial application with autofill"
    And the vendor completes information related to "gmail contributors creation"
    And the "Contributor A is" logged into the certify application
    And the vendor completes information related to "Contributor A Details"
    And the "Contributor B is" logged into the certify application
    And the vendor completes information related to "Contributor B Details"
    And the "Vendor User" logged into the certify application
    And the vendor completes information related to "Individual Contributor Creation"
    And the vendor completes information related to "Individual Contributors Details"
    And the vendor completes information related to "Review and Sign the 8a application"
    And the "Supervisor" logged into the certify application
    And the "Supervisor assigns district office for" the initial eight-a certify application
    And the "Supervisor assigns" the initial eight-a certify application
    And the "Analyst" logged into the certify application
    And the "analyst sends 15 day letter (Return to Firm for Revisions) for" the initial eight-a certify application
    And the "Vendor User" logged into the certify application
    And the vendor completes information related to "Review and Sign the 8a application for returned 15 day letter"
    And the "Analyst" logged into the certify application
    And the "analyst completes returned 15 day screening of" the initial eight-a certify application
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
    And the vendor completes information related to "contributor annual review completion"
    And the "District Supervisor" logged into the certify application
    And the "Unassigned view for District Supervisor of" the annual review flow
    And the "District Supervisor assigns" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst sends a deficiency letter for" the annual review flow
    And the "Vendor User" logged into the certify application
    And the "Vendor User completes the deficiency letter for" the annual review flow
    And the "District Analyst" logged into the certify application
    And the "District Analyst completes screening and processing of" the annual review flow
    And the "District Analyst verifies the documents of" the annual review flow
    When the "District Analyst completes the Retain Firm for" the annual review flow