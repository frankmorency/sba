require 'feature_helper'
require 'rake'
Rails.application.load_tasks

feature '8(a) Initial Application Workflow' do
  before do
    @vendor_in_philly = create_user_vendor_admin
    @supervisor_8a_cods_in_philly = create_user_sba :sba_supervisor_8a_cods
    @director = create_user_sba :sba_supervisor_8a_hq_program
    @director.roles_map = {"HQ_PROGRAM"=>{"8a"=>["supervisor"]}}
    @director.save!
    @aa = create_user_sba :sba_supervisor_8a_hq_aa
    @aa.roles_map =  {"HQ_AA"=>{"8a"=>["supervisor"]}}
    @aa.save!
    @district_supervisor = create_user_sba :sba_supervisor_8a_district_office
    @district_supervisor.roles_map =  {"DISTRICT_OFFICE"=>{"8a"=>["supervisor"]}}
    @district_supervisor.save!
    @district_director = create_user_sba :sba_director_8a_district_office
    @district_director.roles_map =  {"DISTRICT_OFFICE"=>{"8a"=>["supervisor"]}}
    @district_director.save!
    @master_application = nil
  end

  scenario 'Happy Path', js: true do
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
      assign_district_office('Baltimore')

      # begin processing the case
      begin_processing_the_case(@vendor_in_philly.organization.name)
      click_link 'Return to application'

      # create SBA Note
      sba_note_8a_initial()
      compose_initial_sba_note()


      # recommend eligiblility
      make_recommendation('reconsider_yes', nil)
      @vendor_in_philly.organization.certificates[0].workflow_state.should == 'pending'
      @vendor_in_philly.organization.certificates[0].reviews[0].sba_application.workflow_state.should == 'submitted'
      page.find('.usa-button-big').click
      should_have_content 'Eligible (Recommended)'
    end

  end

  scenario 'Closing a case', js: true do
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
      assign_district_office('Baltimore')

      # begin processing the case
      begin_processing_the_case(@vendor_in_philly.organization.name)
      click_link 'Return to application'

      # Close the case
      click_button 'Actions'
      click_link 'Close this case'
      fill_in_generic_note
      fill_in 'Subject', with: 'You are closed'
      page.find(".ql-editor").set("\tBody of Message")
      click_button 'Next'
      @vendor_in_philly.organization.certificates[0].workflow_state.should == 'pending'
      click_button 'Close case'
      should_have_content 'This application has been successfully closed.'
      @vendor_in_philly.organization.certificates[0].reviews[0].workflow_state.should == 'closed'
    end
  end

  scenario 'Reject Determination Path', js: true do
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
      assign_district_office('Baltimore')

      # begin processing the case
      begin_processing_the_case(@vendor_in_philly.organization.name)
      click_link 'Return to application'

      # recommend eligible.
      make_recommendation("reconsider_no", "reconsideration_yes")
      # as_user @sba_supervisor_8a_hq_aa do
      #   visit("/")
      # end
    end
  end

  scenario 'Reject Determination Path, moves from  Pending Reconsideration or Appeal to SBA-Declined after 55 days', js: true do
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
      assign_district_office('Baltimore')

      # begin processing the case
      begin_processing_the_case(@vendor_in_philly.organization.name)
      click_link 'Return to application'

      # recommend eligible.
      make_recommendation("reconsider_no", "reconsideration_yes")
    end

    as_user @director do
      visit('/')
      click_link @vendor_in_philly.organization.name
      make_recommendation("reconsider_no", "reconsideration_yes")
    end

    as_user @aa do
      # Make determination
      visit('/')
      click_link @vendor_in_philly.organization.name
      make_determination("reconsider_no", "reconsideration_yes")
      should_have_content 'has been determined Ineligible'
    end

    as_user @vendor_in_philly do
      visit('/')
      click_link 'Reconsideration or Appeal'
      should_have_content 'Do you want to request reconsideration or appeal?'
      r = Review.first
      r.workflow_state.should eq("pending_reconsideration_or_appeal")
      c = r.certificate
      c.workflow_state.should eq('ineligible')
      master_app = SbaApplication::MasterApplication.where(certificate: c).first
      master_app.workflow_state.should eq('draft')
      Rake::Task['review:appeal_expired'].invoke
      Rake::Task["review:appeal_expired"].reenable
      r = Review.first
      r.workflow_state.should eq("pending_reconsideration_or_appeal")
      c = r.certificate
      c.workflow_state.should eq('ineligible')
      master_app = SbaApplication::MasterApplication.where(certificate: c).first
      master_app.workflow_state.should eq('draft')
      r.reconsideration_or_appeal_clock = Date.today - 80
      r.save!
      Rake::Task['review:appeal_expired'].invoke
      r = Review.first
      r.workflow_state.should eq("closed")
      c = r.certificate
      c.workflow_state.should eq('ineligible')
      master_app = SbaApplication::MasterApplication.where(certificate: c).first
      master_app.workflow_state.should eq('complete')
    end

  end
end
