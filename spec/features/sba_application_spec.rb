=begin
require 'feature_helper'

feature 'Sba Application' do
  before :each do
    @certificate_type = load_sample_questionnaire
    @vendor = create_user_vendor_admin
    @super = create_user_sba_supervisor

    allow_any_instance_of(Organization).to receive(:name).and_return "The Biz"
    allow_any_instance_of(Organization).to receive(:legal_business_name).and_return("The Company")
    BusinessType.create!(name: 'llc', display_name: 'Limited Liability Corporation')

    begin
        begin
          # Delete all indexes in ES
          CasesIndex.delete!
        rescue
        end
        # Recreate all indexes in ES
        CasesIndex.create!
    end

  end

  scenario 'that is submitted, returned and resubmitted...', js: true do
    #@screenshot = true

    as_user @vendor do
      manually_create_a_pending_application @certificate_type
      should_have_content 'My SBA Contracting Programs', 'EDWOSB Self-Certification', 'Active', 'Self Certified'
      should_have_quantity "table#certifications tbody tr", 1
    end

    # then the supervisor logs in
    as_user @super do
      # navigates to a case overview page
      visit '/sba_analyst/cases'
      should_have_content 'EDWOSB', 'Submitted'
      should_have_quantity "table.searchable tbody tr", 1
      click_button 'search-all-cases-button'
      click_link 'The Company'

      # expects to see the new version banner US1653
      should_not_have_content "View previous version"

      # checks the revision history (should only have one entry)
      click_link 'Revision history'
      should_have_quantity 'table tbody tr', 1
      within('table') do
        should_have_content 'Version 1', 'Submitted'
        should_not_have_content 'Version 2', 'Inactive'
      end

      # goes back and returns the app for modification
      visit '/sba_analyst/cases'
      click_button 'search-all-cases-button'
      click_link 'The Company'
      click_link 'Vendor Overview'
      should_have_content 'EDWOSB Self-Certification', 'Active', 'Self Certified'
      click_link 'Return to Vendor'
      should_have_content 'A new application has been reopened for the vendor'
    end

    as_user @vendor do
      # the user resubmits without changing anything
      visit '/vendor_admin/dashboard'
      should_have_content 'Draft'
      # make sure they don't see the old version
      should_not_have_content 'Invalid', 'Submitted'
      should_have_quantity "table#certifications tbody tr", 1
      click_link 'EDWOSB Self-Certification'
      click_link 'Review'
      finish_application

      # should still only show the latest version
      should_have_content 'Active', 'Self Certified'
      should_not_have_content 'Draft', 'Invalid', 'Submitted'
      should_have_quantity 'table#certifications tbody tr', 1
    end

    # the supervisor checks again...
    # creates a review, adds assessments and returns for modification
    as_user @super do
      visit '/sba_analyst/cases'
      should_have_content 'EDWOSB', 'Submitted'
      should_have_quantity 'table.searchable tbody tr', 1
      click_button 'search-all-cases-button'
      click_link 'The Company'

      # expects to see the new version banner US1653
      should_have_content "New version (v2) created",
                          "viewing the most recent version of this application"
      new_window = window_opened_by { click_link "View previous version" }
      within_window new_window do
        # should have read only banner US1652
        # should_have_content 'EDWOSB Program Self-Certification Summary', 'You are in view-only mode', 'Version #1'
      end

      # making sure there are multiple versions
      click_link 'Revision history'
      should_have_quantity 'table tbody tr', 2
      within('table') do
        should_have_content 'Version 2', 'Version 1', 'Submitted', 'Inactive'
      end
      new_window = window_opened_by { click_link 'Version 1' }
      within_window new_window do
        # should_have_content 'EDWOSB Program Self-Certification Summary', 'You are in view-only mode', 'Version #1'
      end

      # Create the review...
      click_link 'Case overview'
      #click_button 'Start'
      #click_link 'Signature review'
      #click_link 'Question review'
      #click_link 'Determination'

      #choose 'Return for Modification', visible: false
      #click_button 'Save and commit'
      #should_have_content 'You are in view-only mode (Version #2)', 'Current Reviewer', 'Case overview'

      click_link 'Vendor Overview'
      should_have_content 'EDWOSB Self-Certification', 'Active', 'Self Certified'
      click_link 'Return to Vendor'

    end

    as_user @vendor do
      # the user resubmits once again... changing nothing
      visit '/vendor_admin/dashboard'
      should_have_content 'Draft'
      # make sure they don't see the old version
      should_not_have_content 'Invalid', 'Submitted'
      should_have_quantity "table#certifications tbody tr", 1
      click_link 'EDWOSB Self-Certification'
      click_link 'Review'
      finish_application

      # should still only show the latest version
      should_have_content 'Active', 'Self Certified'
      should_not_have_content 'Draft', 'Invalid', 'Submitted'
      should_have_quantity 'table#certifications tbody tr', 1
    end

    # the supervisor creates a review, adding assessments and then returning for mod...
    as_user @super do
      visit '/sba_analyst/cases'
      should_have_content 'EDWOSB', 'Submitted'
      should_have_quantity 'table.searchable tbody tr', 1
      click_button 'search-all-cases-button'
      click_link 'The Company'

      # expects to see the new version banner US1653
      should_have_content "New version (v3) created",
                          "viewing the most recent version of this application"

      # making sure there are multiple versions
      click_link 'Revision history'
      should_have_quantity 'table tbody tr', 3
      within('table') do
        should_have_content 'Version 3', 'Version 2', 'Version 1', 'Submitted', 'Inactive'
      end
    end
  end

  scenario 'Disqualifying for an application', js: true do
    as_user @vendor do
      visit '/certificate_types/edwosb/application_types/initial/sba_applications/new'
      should_have_content "The Questionnaire Program Certification"
      click_button 'Accept'

      should_have_content "Eligibility"
      page.find('#answers_must_answer_yes label.no').trigger(:click)
      page.find('#answers_must_answer_no label.no').trigger(:click)
      click_button 'Save and continue'

      should_have_content 'You are ineligible', 'Because you said no.'
      click_link 'Go back and change your responses'

      should_have_content "Eligibility"
      page.find('#answers_must_answer_yes label.yes').trigger(:click)
      click_button 'Save and continue'

      should_have_content "How Big"
      page.find('#answers_is_it_big label.no').trigger(:click)
      click_button 'Save and continue'

      should_have_content "Other Questions"
      page.find('#answers_do_you_like_it label.yes').trigger(:click)
      click_button 'Save and continue'

      should_have_content "Review"
      # Yes... I have to do this or the stupid accordion content won't show
      sleep 3
      page.execute_script "$('.tab-content').show();"
      sleep 1
      # end what I shouldn't have to do...
      within '#must_answer_yes' do
        click_link 'Change answer'
      end

      should_have_content "Eligibility"
      page.find('#answers_must_answer_no label.yes').trigger(:click)
      click_button 'Save and continue'

      should_have_content 'You are ineligible', 'Because you said yes.'
      click_link 'Discard your application'

      should_have_content 'You have not started an application'
    end
  end
end
=end

