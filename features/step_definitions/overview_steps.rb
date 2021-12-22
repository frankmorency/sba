When("the vendor completes information related to {string}") do |string|

  case string

  when "Character Details"
    on(OverviewPage).overview_selection("Character Details", "Check status of application")
    on(OverviewPage).overview_selection("Character Details", "Character")
    on(CharacterInformationPage).complete_character_section(string, "Character")
    on(CharacterInformationPage).complete_character_section(string, "Review Submit")

  when "Business Ownership Details"
    on(OverviewPage).overview_selection("Business Ownership Details", "Check status of application")
    on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as yes")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit")

  when "Business Ownership with no LLC Details"
    on(OverviewPage).overview_selection("Business Ownership Details", "Check status of application")
    on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as no")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit")

  when "Business Ownership with LLC Details"
    on(OverviewPage).overview_selection("Business Ownership Details", "Check status of application")
    on(OverviewPage).overview_selection("Business Ownership Details", "Business Ownership")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Firm Ownership as no")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Ownership Details as yes")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Corporations")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "LLCs")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Partnerships")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Sole Proprietors")
    on(BusinessOwnershipPage).complete_business_ownership_section(string, "Review Submit")

  when "Individual Contributor Creation"
    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    on(OverviewPage).overview_selection("Individual Contributors Details", "Check status of application")
    on(OverviewPage).overview_selection("Individual Contributors Details", "Individual Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Individual Application Now")

  when "Individual Contributors Details"
    on(ContributorsPage).complete_all_contributor_section(string, "General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Basis of Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")

  when "gmail contributors creation"
    on(OverviewPage).overview_selection("Multiple Contributors Details","Multiple Contributors")
    on(LoginPage).complete_login_actions(string, "ContributorA")
    on(LoginPage).complete_login_actions(string, "ContributorB")
    ## COMMENT ONLY: Contributor C is not implemented in automation at present ##
    # on(LoginPage).complete_login_actions(string, "ContributorC")

    on(LoginPage).total_logout()
    on(GmailContributorPage).clean_up_junk_emails()

    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_login_actions(string, "Contributor A Registration")
    on(GmailContributorPage).email_click("Confirm Your certify.SBA.gov account")

    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_login_actions(string, "Contributor B Registration")
    on(GmailContributorPage).email_click("Confirm Your certify.SBA.gov account")


    ## COMMENT ONLY: Contributor C is not implemented in automation at present ##
    # visit HomePage
    # on(HomePage).get_started.wait_until_present(timeout: 10).click
    # on(LoginPage).complete_login_actions(string, "Contributor C Registration")
    # on(GmailContributorPage).email_click("Confirm Your certify.SBA.gov account")







  when "Multiple Contributors Creation"
    on(OverviewPage).overview_selection("Multiple Contributors Details", "Multiple Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_A")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_B")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_C")
    on(LoginPage).total_logout()


  when "One Contributor Creation"
    on(OverviewPage).overview_selection("Multiple Contributors Details", "Multiple Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_A1")
    on(LoginPage).total_logout()

  when "Two Contributors Creation"
    on(OverviewPage).overview_selection("Multiple Contributors Details", "Multiple Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_A2")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_B2")
    on(LoginPage).total_logout()


  when "Multiple Contributors creation and deletion"
    on(OverviewPage).overview_selection("Multiple Contributors Details", "Multiple Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_A")
    on(ContributorsPage).complete_contributor_section(string, "Delete Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_B")
    on(ContributorsPage).complete_contributor_section(string, "Delete Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Contributors_C")
    on(ContributorsPage).complete_contributor_section(string, "Delete Contributors")
    on(LoginPage).total_logout()

  when "Multiple Contributors Details"
    on(OverviewPage).overview_selection("Multiple Contributors Details", "Multiple Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Multiple Contributors")


  when "Contributor A Details"
    on(OverviewPage).overview_selection("Contributor A Details", "Start Application")
    on(ContributorsPage).complete_all_contributor_section(string, "General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Basis of Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(LoginPage).total_logout()

  when "Contributor B Details"
    on(OverviewPage).overview_selection("Contributor B Details", "Start Application")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(LoginPage).total_logout()

  when "Contributor A1 Details"
    on(OverviewPage).overview_selection("Contributor A1 Details", "Start Application")
    on(ContributorsPage).complete_all_contributor_section(string, "General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Basis of Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(LoginPage).total_logout()

  when "Contributor A2 Details"
    on(OverviewPage).overview_selection("Contributor A2 Details", "Start Application")
    on(ContributorsPage).complete_all_contributor_section(string, "General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Basis of Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(LoginPage).total_logout()

  when "Contributor B2 Details"
    on(OverviewPage).overview_selection("Contributor B2 Details", "Start Application")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Spouse Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(LoginPage).total_logout()

  when "Potential for Success Details"
    on(OverviewPage).overview_selection("Potential for Success Details", "Check status of application")
    on(OverviewPage).overview_selection("Potential for Success Details", "Potential for Success")
    on(PotentialForSuccessPage).complete_potential_for_success_section(string, "Taxes")
    on(PotentialForSuccessPage).complete_potential_for_success_section(string, "Revenue")
    on(PotentialForSuccessPage).complete_potential_for_success_section(string, "Potential for Success")
    on(PotentialForSuccessPage).complete_potential_for_success_section(string, "Review Submit")

  when "Control Details"
    on(OverviewPage).overview_selection("Control Details", "Check status of application")
    on(OverviewPage).overview_selection("Control Details", "Control")
    on(ControlPage).complete_control_section(string, "Firm Control")
    on(ControlPage).complete_control_section(string, "Leased Facility")
    on(ControlPage).complete_control_section(string, "Review Submit")

  when "Review and Sign the 8a application"
    on(OverviewPage).overview_selection("Individual Contributors Details", "Final status of application")
    on(OverviewPage).overview_selection("Individual Contributors Details", "Review and Sign")
    on(LoginPage).total_logout()

  when "Review and Sign the 8a application for returned 15 day letter"
    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    on(OverviewPage).overview_selection("Individual Contributors Details", "Send 15 day returned completed")
    on(LoginPage).total_logout()

  when "Vendor Admin Contributor autofill"
    on(OverviewPage).overview_selection("Individual Contributors Details", "Individual Contributors")
    on(ContributorsPage).complete_contributor_section(string, "Individual Application Now")
    on(WelcomePage).vendor_admin_fill()
    on(WelcomePage).assert_complete_section("Notice", "Your app has been prepopulated - you can now go submit it")
    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click

  when "eight-a annual review with autofill"
    on(WelcomePage).vendor_create_annual_review()
    on(WelcomePage).new_page_click()
    on(WelcomePage).click_application("Annual Review","Draft")
    on(WelcomePage).initial_ar_fill()
    on(WelcomePage).assert_complete_section("Notice", "Your app has been prepopulated - you can now go submit it")

  when "eight-a contributor annual review with autofill"
    on(WelcomePage).new_page_click()
    on(WelcomePage).click_application("Annual Review","Draft")
    on(OverviewPage).overview_selection("Individual Contributors Details", "Contributors")
    on(ContributorsPage).complete_contributor_section(string,"Browser Status")
    on(ContributorsPage).complete_contributor_section(string, "Individual Annual Review Application Now")
    on(ContributorsPage).complete_contributor_section(string,"Browser Status")
    on(WelcomePage).vendor_admin_fill()
    on(WelcomePage).assert_complete_section("Notice", "Your app has been prepopulated - you can now go submit it")
    on(WelcomePage).click_complete_application("Annual Review","Draft")
    on(OverviewPage).overview_selection("Annual Review Submission", "Review Multiple Sign")
    on(LoginPage).total_logout()

  when "contributor annual review completion"
    on(WelcomePage).new_page_click()
    on(WelcomePage).click_application("Annual Review","Draft")
    on(OverviewPage).overview_selection("Individual Contributors Details", "Contributors")
    on(ContributorsPage).complete_contributor_section(string,"Browser Status")
    on(ContributorsPage).complete_contributor_section(string, "Individual Annual Review Application Now")
    on(ContributorsPage).complete_contributor_section(string,"Browser Status")
    on(ContributorsPage).complete_all_contributor_section(string, "General Information")
    on(ContributorsPage).complete_all_contributor_section(string, "Resume")
    on(ContributorsPage).complete_all_contributor_section(string, "Ownership and Control")
    on(ContributorsPage).complete_all_contributor_section(string, "Prior 8(a) Involvement")
    on(ContributorsPage).complete_all_contributor_section(string, "Character")
    on(ContributorsPage).complete_all_contributor_section(string, "Basis of Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Economic Disadvantage")
    on(ContributorsPage).complete_all_contributor_section(string, "Review Submit")
    on(ContributorsPage).complete_all_contributor_section(string, "Signature")
    on(ContributorsPage).complete_all_contributor_section(string, "Status")
    on(WelcomePage).new_page_click()
    on(WelcomePage).click_complete_application("Annual Review","Draft")
    on(OverviewPage).overview_selection("Annual Review Submission", "Review Multiple Sign")
    on(LoginPage).total_logout()

  end
end

Then("the vendor {string} is received by sba portal for review") do |string|
  #pending # Write code here that turns the phrase above into concrete actions
end
