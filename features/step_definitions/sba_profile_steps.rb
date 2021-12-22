Given("the {string} the initial eight-a certify application") do |string|
  case string

  when "Supervisor assigns"
    d = DateTime.now
    d.strftime("%d/%m/%Y %H:%M")
    date = d.strftime("%m/%d/%Y")
    on(SBAProfilesPage).assign_application(date, "Initial")
    on(LoginPage).total_logout()

  when "Supervisor assigns district office for"
    d = DateTime.now
    d.strftime("%d/%m/%Y %H:%M")
    date = d.strftime("%m/%d/%Y")
    on(SBAProfilesPage).find_application(date, "Initial")
    on(SBAProfilesPage).select_district_office(date)

  when "Unassigned view for CODS Supervisors of"
    d = DateTime.now
    d.strftime("%d/%m/%Y %H:%M")
    date = d.strftime("%m/%d/%Y")
    on(SBAProfilesPage).unassigned_view()
    on(SBAProfilesPage).find_application(date, "Initial")

  when "analyst completes screening of"
    d = DateTime.now
    new_date = DateTime.now.next_day(15).to_time
    date_15 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).start_screening(date_15)
    on(SBAProfilesPage).assign_station()

  when "analyst completes returned 15 day screening of"
    d = DateTime.now
    new_date = DateTime.now.next_day(10).to_time
    date_10 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).click_screening(date_10)
    on(SBAProfilesPage).initial_begin_processing("Begin processing this case")

  when "analyst sends 15 day letter (Return to Firm for Revisions) for"
    d = DateTime.now
    new_date = DateTime.now.next_day(15).to_time
    date_15 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).click_screening(date_15)
    on(SBAProfilesPage).return_to_firm("Return to firm for revisions", "Returned With 15 Day Letter", date_15)
    on(LoginPage).total_logout()

  when "analyst completes processing and Make recommendation of"
    d = DateTime.now
    new_date = DateTime.now.next_day(90).to_time
    date_90 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).start_processing_date(date_90)
    on(SBAProfilesPage).analyst_make_recommendation(date_90)
    on(LoginPage).total_logout()

  when "supervisor completes Make recommendation of"
    d = DateTime.now
    new_date = DateTime.now.next_day(90).to_time
    date_90 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).initial_8a_date_processing("Processing", date_90)
    on(SBAProfilesPage).supervisor_make_recommendation(date_90)
    on(LoginPage).total_logout()

  when "supervisor hq program completes Make recommendation of"
    d = DateTime.now
    new_date = DateTime.now.next_day(90).to_time
    date_90 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).initial_8a_date_processing("Processing", date_90)
    on(SBAProfilesPage).supervisor_hq_program_make_recommendation(date_90)
    on(LoginPage).total_logout()

  when "supervisor hq aa completes Make determination of"
    d = DateTime.now
    new_date = DateTime.now.next_day(90).to_time
    date_90 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).initial_8a_date_processing("Processing", date_90)
    on(SBAProfilesPage).supervisor_hq_aa_make_determination(date_90)
    on(LoginPage).total_logout()

  when "Vendor User gets status certified for"
    d = DateTime.now
    sub_date = d.strftime("%m/%d/%Y")
    new_date = DateTime.now.next_day(3286).to_time
    date_exp_9yr = new_date.strftime("%m/%d/%Y")
    puts date_exp_9yr
    visit HomePage
    on(HomePage).sign_in.wait_until_present(timeout: 10).click
    on(LoginPage).login_data_yml("Vendor User")
    on(WelcomePage).application_status_view("8(a) Initial Application", "Certificate", "Active", sub_date, date_exp_9yr, "", "")

  end
end

Given("the {string} the annual review flow") do |string|
  case string

  when "Unassigned view for District Supervisor of"
    d = DateTime.now
    d.strftime("%d/%m/%Y %H:%M")
    date = d.strftime("%m/%d/%Y")
    on(SBAProfilesPage).unassigned_view()
    on(SBAProfilesPage).find_application(date, "Annual Review")

  when "District Supervisor assigns"
    d = DateTime.now
    d.strftime("%d/%m/%Y %H:%M")
    date = d.strftime("%m/%d/%Y")
    on(SBAProfilesPage).assign_annual_review_application(date, "Annual Review")
    on(LoginPage).total_logout()

  when "district analyst initiates deficiency letter for"
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    d = DateTime.now
    new_date = d.next_day(15).to_time
    date_15 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_date_processing("Screening",date_15)
    on(SBAProfilesPage).sba_funbar_action("Send a Deficiency Letter")

  when "District Analyst completes screening and processing of"
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    #Screening of the annual reviews
    d = DateTime.now
    new_date = d.next_day(10).to_time
    date_10 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_screening("Annual Review", "Screening".strip,date_10)
    # on(SBAProfilesPage).assert_funbar("Screening",date_10)
    on(SBAProfilesPage).annual_review_begin_processing("Begin processing this case")
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")

    #Processing of the annual reviews
    d = DateTime.now
    new_date = d.next_day(30).to_time
    date_30 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_date_processing("Processing", date_30)
    on(SBAProfilesPage).assert_funbar("Processing",date_30)

  when "District Analyst verifies the documents of"
    on(SBAProfilesPage).sba_upload("Upload documents")

  when "District Analyst completes the Retain Firm for"
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    d = DateTime.now
    new_date = d.next_day(30).to_time
    date_30 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_date_processing("Processing", date_30)
    on(SBAProfilesPage).sba_funbar_action("Retain firm")
    on(SBAProfilesPage).send_message("Retain Subject","Analyst Retains this firm for annual reviews","Next","Complete this Annual Review")
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    on(SBAProfilesPage).find_application_status("Annual Review", "Retained")
    on(LoginPage).total_logout()

  when "District Analyst completes the Send Letter of Intent to Terminate for"
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    d = DateTime.now
    new_date = d.next_day(30).to_time
    date_30 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_date_processing("Processing", date_30)
    on(SBAProfilesPage).sba_funbar_action("Letter of intent to terminate")
    on(SBAProfilesPage).send_message_terminate("Intent to Terminate Subject","Analyst Terminates this firm for annual reviews","Next","Send letter")

    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    on(SBAProfilesPage).find_application_status("Annual Review", "Processing")

  when "District Analyst initiate adverse action on"
    on(WelcomePage).dashboard_user("eight_a_initial_sba_analyst")
    d = DateTime.now
    new_date = d.next_day(30).to_time
    date_30 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_date_processing("Processing", date_30)
    on(SBAProfilesPage).sba_funbar_action("Initiate Adverse Action")
    on(LoginPage).total_logout()

  when "District Analyst sends a deficiency letter for"
    d = DateTime.now
    new_date = d.next_day(15).to_time
    date_15 = new_date.strftime("%m/%d/%Y")
    on(SBAProfilesPage).annual_review_processing("Annual Review", "Screening", date_15)
    on(SBAProfilesPage).annual_review_deficiency_letter()
    on(LoginPage).total_logout()

  when "Vendor User completes the deficiency letter for"
    on(WelcomePage).click_application("Annual Review", "Returned")
    on(OverviewPage).overview_selection("Individual Contributors Details", "Annual Review Send deficiency letter 15 day returned completed")
    on(LoginPage).total_logout()

  when "Vendor User gets the final status of"
    visit HomePage
    on(HomePage).sign_in.wait_until_present(timeout: 10).click
    on(LoginPage).login_data_yml("Vendor User")


  end
end