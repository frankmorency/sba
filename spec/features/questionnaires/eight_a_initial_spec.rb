require 'feature_helper'

feature '8(a) Initial Application' do
  before do
    @vendor = create_user_vendor_admin
  end

  scenario 'Happy Path', js: true do
    as_user @vendor do
      visit '/vendor_admin/dashboard'
      click_link '8(a) Initial Application'
      click_button 'Accept'

      # Fill out Eligibility
      should_be_on_section 'General Assessment'
      answer_question :for_profit, 'Yes'
      answer_question :is_broker, 'No'
      answer_question :generate_revenue, 'Yes'
      answer_question :disadvantaged_citizens_updated, 'Yes'
      answer_question :have_dba_updated, 'No'
      save_and_continue

      should_be_on_section 'Prior 8(a) Involvement'
      answer_question :eighta_certified, 'No'
      answer_question :submitted_app_to_8a, 'No'
      answer_question :previous_participant_assets_over_50_percent, 'No'
      save_and_continue

      should_be_on_section 'Outside Assistance'
      answer_question :outside_consultant, 'No'
      save_and_continue

      should_be_on_section 'Business Size'
      answer_question :formal_determination, 'No'
      answer_question :small_naics, 'No'
      save_and_continue

      should_be_on_section "Review"
      click_button 'Submit'

      should_have_page_content 'Success', '8(a) Basic Eligibility section is complete', '8(a) Initial Application', 'Application Overview'
      expect(current_path).to match(/\/sba_application\/(\d+)\/application_dashboard\/overview/)

      # fill out the other sub applications...
    end
  end
end
