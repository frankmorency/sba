require 'feature_helper'

feature '8(a) Annual Application Workflow' do
  before do
    @program_sba_analyst = create_user_sba_analyst
    @program_sba_analyst.roles_map = {"HQ_PROGRAM"=>{"8a"=>["analyst"]}}
    @program_sba_analyst.save!
    @ce_sba_analyst = create_user_sba_analyst
    @ce_sba_analyst.roles_map = {"HQ_CE"=>{"8a"=>["analyst"]}}
    @ce_sba_analyst.save!
    @vendor_in_philly = create_user_vendor_admin
    @supervisor_8a_cods_in_philly = create_user_sba :sba_supervisor_8a_cods
    @supervisor_8a_cods_in_philly.roles_map = {"CODS"=>{"8a"=>["supervisor"]}}
    @supervisor_8a_cods_in_philly.save!
    @director = create_user_sba :sba_supervisor_8a_hq_program
    @director.roles_map = {"HQ_PROGRAM"=>{"8a"=>["supervisor"]}}
    @director.save!
    @aa = create_user_sba :sba_supervisor_8a_hq_aa
    @aa.roles_map =  {"HQ_AA"=>{"8a"=>["supervisor"]}}
    @aa.save!
    @district_supervisor = create_user_sba :sba_supervisor_8a_district_office
    @district_supervisor.roles_map =  {"DISTRICT_OFFICE"=>{"8a"=>["supervisor"]}}
    @district_supervisor.save!
    @district_director = create_user_sba :sba_supervisor_8a_district_office
    @district_director.roles_map =  {"DISTRICT_OFFICE_DIRECTOR"=>{"8a"=>["supervisor"]}}
    @district_director.save!
    @master_application = nil
  end

  scenario 'Create 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      assign_district_office('Philadelphia')

      # create SBA Note
      sba_note_8a_initial()
      compose_initial_sba_note()
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'
      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      # Create SBA NOTES for Annual Reviews
      sba_note_8a_annual_review()
      compose_annual_sba_note()
    end
  end

  scenario 'Finalize 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")
      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      select 'Philadelphia', from: 'field_office'
      click_button 'Set District Office'
      page.driver.browser.switch_to.alert.accept
      should_have_content 'Success', 'The district office has been updated'
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'

      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      # Create SBA NOTES for Annual Reviews
      sba_note_8a_annual_review()
      compose_annual_sba_note()
      click_button 'Actions'
      click_link 'Initiate adverse action'
      choose 'Voluntary withdrawal', allow_label_click: true
      click_button 'Next'
      choose @aa.full_name, allow_label_click: true
      click_button 'Next'
      click_button 'Next'
      fill_in_generic_note
      page.find('label[for=accept_terms]').click
      click_button 'Send to HQ'
    end

    as_user @aa do
      sleep 5
      visit('/eight_a_initial_sba_supervisor/dashboard')
      click_link @vendor_in_philly.organization.name
      click_button 'Actions'
      click_link 'Finalize adverse action'
      choose 'Voluntary withdrawal', allow_label_click: true
      click_button 'Next'
      click_button 'Next'
      fill_in_generic_note
      # Nobody to foward it to
      click_button 'Finalize'
      should_have_page_content 'HQ will now process the termination'
    end

    as_user @vendor_in_philly  do
      # visit("vendor_admin/dashboard")
      # page.find('label', text: 'Yes').click
      # click_button 'Submit'
      # within('table#certifications') do
      #   should_have_content 'Closed'
      # end
    end
  end

  scenario 'Terminate Link 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      select 'Philadelphia', from: 'field_office'
      click_button 'Set District Office'
      page.driver.browser.switch_to.alert.accept
      should_have_content 'Success', 'The district office has been updated'
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'

      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name

      click_button 'Actions'
      click_link 'Letter of intent to terminate'
      fill_in 'Subject', with: 'You are closed'
      page.find(".ql-editor").set("\tBody of Message")
      click_button 'Next'
      page.find("label[for='assert_approval']").click
      click_button 'Send letter'
      # @vendor_in_philly.organization.certificates[0].current_review
      should_have_content 'Your Letter of Intent to Terminate has been sent'
      # Certificate.all[0].reviews[0].sba_application
      # @vendor_in_philly.organization.certificates[0].reviews[0].sba_application
    end
  end

  scenario 'Finalize 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      select 'Philadelphia', from: 'field_office'
      click_button 'Set District Office'
      page.driver.browser.switch_to.alert.accept
      should_have_content 'Success', 'The district office has been updated'
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'

      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      # Create SBA NOTES for Annual Reviews
      sba_note_8a_annual_review()
      compose_annual_sba_note()
      click_button 'Actions'
      click_link 'Initiate adverse action'
      choose 'Voluntary withdrawal', allow_label_click: true
      click_button 'Next'
      choose @aa.full_name, allow_label_click: true
      click_button 'Next'
      click_button 'Next'
      fill_in 'Title', with: 'You are closed'
      fill_in 'Note', with: 'closing it up'
      page.find('label', text: 'BOS Analysis').click
      click_button 'Next'
      page.find('label[for=accept_terms]').click
      click_button 'Send to HQ'
    end

    as_user @aa do
      sleep 3
      visit("eight_a_initial_sba_supervisor/dashboard")
      click_link @vendor_in_philly.organization.name
      click_button 'Actions'
      click_link 'Finalize adverse action'
      choose 'Voluntary withdrawal', allow_label_click: true
      click_button 'Next'
      click_button 'Next'
      fill_in 'Title', with: 'You are closed'
      fill_in 'Note', with: 'closing it up'
      page.find('label', text: 'BOS Analysis').click
      click_button 'Next'
      # Nobody to foward it to.
      click_button 'Finalize'
      should_have_page_content 'HQ will now process the termination'
    end

    as_user @vendor_in_philly  do
      sleep 3
      visit("vendor_admin/dashboard")
      # page.find('label', text: 'Yes').click
      # click_button 'Submit'
      within('table#certifications') do
        should_have_content 'Closed'
      end
    end
  end

  scenario 'Terminate Link 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      select 'Philadelphia', from: 'field_office'
      click_button 'Set District Office'
      page.driver.browser.switch_to.alert.accept
      should_have_content 'Success', 'The district office has been updated'
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'

      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      click_button 'Actions'
      click_link 'Letter of intent to terminate'
    end
  end


  scenario 'BOS User does Program Level Actions for 8(a) Annual', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
      fill_out_wosb
      fill_out_mentor
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      assign_district_office('Philadelphia')
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'
      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      page.all("svg.sba-c-icon--blue")[1].click
      page.all('.radio_label')[0].click
      click_button "Select servicing BOS"
      click_link @vendor_in_philly.organization.name
      click_button 'Actions'
    end
  end

  scenario 'Firm overview page', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
      fill_out_wosb
      fill_out_mentor
    end

    as_user @supervisor_8a_cods_in_philly do
      visit("/")
      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor_in_philly.organization.name
        click_link 'Assign'
      end
      # assign it to themselves
      choose @supervisor_8a_cods_in_philly.full_name, allow_label_click: true
      click_button 'Assign'
      should_have_heading "This case been assigned to #{@supervisor_8a_cods_in_philly.full_name}"

      click_link @vendor_in_philly.organization.name
      # assign to a district office
      assign_district_office('Philadelphia')
    end

    as_user @vendor_in_philly  do
      visit("/sba_applications/#{@master_application.id}/create_annual_review")
      should_have_content "Your annual review was created."
      @master_annual_review = SbaApplication.where(kind: "annual_review").first
      visit("/sba_applications/#{@master_annual_review.id}/fill")
      click_link "8(a) Annual Review"
      click_link 'Contributors'
      click_link 'Firm Owner Questionnaire'
      current_path =~ /\/sba_applications\/(\d+)\//
      dvd_app = SbaApplication.find($1)
      auto_fill_application(dvd_app)
      click_link 'Dashboard'
      click_link '8(a) Annual Review'
      click_button 'Sign and submit'
      page.find('label[for=legal_0]').click
      page.find('label[for=legal_1]').click
      page.find('label[for=legal_2]').click
      click_button 'Accept'
      should_have_content 'Your application has been submitted'
    end

    as_user @district_supervisor do
      visit("/")
      click_link "Assign"
      choose @district_supervisor.full_name, allow_label_click: true
      click_button "Assign"
      click_link @vendor_in_philly.organization.name
      page.all("svg.sba-c-icon--blue")[1].click
      page.all('.radio_label')[0].click
      click_button "Select servicing BOS"
      click_link @vendor_in_philly.organization.name
      within page.find("table#certifications-8a") do
        should_have_content 'Annual Review', 'Certificate'
      end
      within page.find("table#certifications-wo") do
        should_have_content 'Certificate'
      end
      within page.find("table#certifications-mentor") do
        should_have_content 'Certificate'
      end
      page.find('.sba-c-task-panel__toggle').click
      sleep 2
      page.all('.sba-c-task-panel__menu__item').count.should == 1
      click_link 'Request additional information'
      should_have_content 'Request additional information outside an 8(a) Annual Review'
    end
  end

end
