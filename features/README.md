# behaviorTest
Ruby Automation Data Driven Framework for Certify Application

## Table of contents
1. [Framework Adaptation](#framework-adaptation)
1. [Framework Overlay of the folder structure](#framework-overlay-of-the-folder-structure])
1. [Windows Setup](#windows-setup)
   

### Framework Adaptation

Adaptation of genericpage and page helper is from  page-object_framework
https://github.com/machzqcq/page-object_framework.git

### Framework Overlay of the folder structure

a) **Feature files for acceptance criteria**
```
features/feature_file >> this folder contains all the feature files to meet the acceptance criteria and
the files have .feature extension
```

b) **Step Definitions to execute the acceptance criteria**
```
features/step_definitions >> this folder contains all the step definition snippets as generated from the feature file. 
The basic usage of the step definition is defined in terms of the particular functionality. e.g, all the step definitions related
to the common login functionality are in **login_steps.rb** for vendors,contributors and SBA administration profiles. 
For the vendor eligibility section, the step definition file **basic_eligibility_steps.rb** is used to complete all sections of the eligibility questionnaire.
To make a manageable approach to handle duplication and redundancy in step definitions,
most of the vendor functionality are in the **overview_steps.rb** to handle different flows of vendor and contributor actions. 
```

c) **Framework driver and miscellaneous configurations:**
     
     ```
     all the supporting files are in support/config.yaml and support/env.rb
     config.yaml contains the environment variables for different urls as like staging,dev, or qa
     env.rb contains logic to instantiate the webdriver, at present browsers actively tested and executed are
     **chrome,chrome-remote(headless),phantomjs**
     ```

d)  **Cucumber Execution by command line**
  based on particular "@tag" in the feature file, issue the following command
  
  
  >> rake features CUCUMBER_TAGS=@tag
  
  **Note** 
  
  
   i) there should not be any space between CUCUMBER_TAGS,equal sign and the @tag
   ii) @wip, feature file with @wip willn't be executed
   iii) to execute all scenarios based on specfic feature file, 
   browser and url preselection is in `features/support/config.yaml `file
   
   >> bundle exec cucumber features/feature_file/Login.feature 

   or 
   
  >>  bundle exec cucumber path_to_feature_file
   
   or will execute all feature files inside the feature_file folder
   
   >> bundle exec cucumber features/feature_file/*.feature
   

   
   

e) **Test Data Binding**

Framework code is crafted in a such a manner to have maximum code reuse, avoid duplication as all repetitive tasks are delegated to yaml test data
 
 **Example:** if the vendor user is a non-llc, then non-llc application sections are incorporated into yml test data file
 while vendor with llc association, will have llc flow in the flow and subsequent sections
 

  ```
  Business Ownership Details: Firm Ownership as yes,Ownership Details as yes,Corporations,Review Submit
  ```

  
  ```
  Business Ownership with no LLC Details: Firm Ownership as no,Ownership Details as yes,Corporations,Review Submit 
  ```  
 
  ```
  Business Ownership with LLC Details: Firm Ownership as no,Ownership Details as yes,Corporations,LLCs,Partnerships,Sole Proprietors,Review Submit
  ```
  
 
 **the corresponding feature file structure is**
  
   ```
   @vendorbusinessownsership 
   Scenario: 1 Login into the certify application and complete below sections
     Given the "Vendor User1" logged into the certify application
     And  the vendor completes the "Eligibility Information"
     And  the vendor completes information related to "Character Details"
     And  the vendor completes information related to "Potential for Success Details"
     And  the vendor completes information related to "Control Details"
     And  the vendor completes information related to "Business Ownership Details"
 
   @vendorbusinessownsership @noLLC
   Scenario: 2 Login into the certify application and complete below sections
     Given the "Vendor User2" logged into the certify application
     And  the vendor completes the "Eligibility Information"
     And  the vendor completes information related to "Character Details"
     And  the vendor completes information related to "Potential for Success Details"
     And  the vendor completes information related to "Control Details"
     And  the vendor completes information related to "Business Ownership with no LLC Details"
 
   @vendorbusinessownsership @LLC
   Scenario: 3 Login into the certify application and complete below sections
     Given the "Vendor User" logged into the certify application
     And  the vendor completes the "Eligibility Information"
     And  the vendor completes information related to "Character Details"
     And  the vendor completes information related to "Potential for Success Details"
     And  the vendor completes information related to "Control Details"
     And  the vendor completes information related to "Business Ownership with LLC Details"
  ```
  
  **the logic to execute and bind the test data is as follows in the step definition case statement**   
  
   ```
     when "Business Ownership Details"
        on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as yes")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit")
  
     
      when "Business Ownership with no LLC Details"
        on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as no")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit")
  
     
      when "Business Ownership with LLC Details"
        on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as no")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "LLCs")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Partnerships")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Sole Proprietors")
        on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit") 

 ```
 
 


###Windows Setup


 **Ruby Installer**

```
https://rubyinstaller.org/downloads/

1) Click ‘I accept the License’ and click ‘Next’.
2) Make sure ‘Add Ruby executables to your PATH’ and ‘Associate .rb and .rbw files with this Ruby installation’ are selected, and click ‘Install’.
3) Let the Installer run, when it’s finished, make sure ‘Run ‘ridk install’…….’ is selected and click ‘Finish’.
4) Now you’ll get to the installer for MSYS2, which we’ll need for a couple of functions in Ruby. Click ‘Next’.
5) Click ‘Next’.
6) Click ‘Next’ and let the installer finish.
7) Once the MSYS2 installer has finished, uncheck ‘Run MSYS now.’ and click ‘Finish’.
8) Ruby is now installed.
```

### Driver setup

```
Firefox gecko
https://github.com/mozilla/geckodriver/releases

Chrome 
https://sites.google.com/a/chromium.org/chromedriver/downloads

extract the respective drivers into particular folder and set that folder path in your environmental variable path
```


### Environment setup

open cmd or powershell cli
```
execute following commands at the root of the git project
a) gem install bundler
b) gem install lapis_lazuli –no-ri –no-rdoc
c) ansicon.exe
d) bundle install
e) bundle update
f) rake features CUCUMBER_TAGS=@sometag >> will execute your particular feature file

Note : Gemfile.lock is specific to windows environment, don’t commit this file
```

