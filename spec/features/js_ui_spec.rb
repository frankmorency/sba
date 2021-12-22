require 'feature_helper'

feature 'JS UI scenarios' do
  before do
    @vendor = create_user_vendor_admin
  end

  scenario 'Eight(8) DatePicker, Full Address, and General Questionnaire Validation, and Accordion UI on workflow', js: true do
    as_user @vendor do
      draft_and_fill_8a_app_for(@vendor)
      visit '/vendor_admin/dashboard'
      click_link "8(a) Initial Application"
      should_not_have_page_content 'Firm Documents'
      click_button 'Documents'
      should_have_page_content 'Firm Documents'
    end
  end

  scenario 'Accordion UI for More Details on homepage and navbar', js: true do
    as_user @vendor do
    	visit '/vendor_admin/dashboard'
    	should_not_have_content 'Business Type:Limited Liability Corporation'
      click_button "More details"
      should_have_content 'Business Type:Limited Liability Corporation'
      should_not_have_content "The .gov means it’s official."
      page.all(".usa-accordion-button")[0].click
      should_have_content "The .gov means it’s official."
      page.all(".usa-accordion-button")[0].click
      should_not_have_content "The .gov means it’s official."
      should_not_have_content "Logout"
      click_button "My Account"
      should_have_content "Logout"
    end
  end

  scenario 'fill out new WOSB', js: true do
    as_user @vendor do
      fill_out_wosb
    end

  end

  scenario 'fill out new Mentor Application', js: true do
    as_user @vendor do
      fill_out_mentor
    end
  end

  # scenario 'fill out new 8a', js: true do
  #     user = User.new(email: "qa_test2@mailinator.com", password: "password")
  #     visit "http://localhost:3000/"
  #     click_link "Login"
  #     fill_in( "User email", with: user.email )
  #     fill_in( "password", with: user.password )
  #     click_button "Sign-in"
  #     visit "http://localhost:3000/sba_applications/16/questionnaires/eight_a_disadvantaged_individual_annual_review/question_sections/gender/edit"
  # end

  scenario 'fill out new 8a, and test overview ajax calls', js: true do
    as_user @vendor do
      login_as @vendor
      visit "vendor_admin/dashboard"
      click_link "8(a) Initial Application"
      click_button "Accept"
      page.all("label")[0].click
      page.all("label")[3].click
      page.all("label")[4].click
      page.all("label")[7].click
      page.all("label")[9].click
      page.all("label")[11].click
      click_button "Save and continue"
      page.all("label")[2].click
      page.all("label")[3].click
      page.all("label")[5].click
      click_button "Save and continue"
      page.all("label")[1].click
      click_button "Save and continue"
      page.all("label")[1].click
      click_button "Save and continue"
      page.all("label")[0].click
      page.all("label")[3].click
      click_button "Save and continue"
      click_button "Submit"
      click_link "Business Ownership"
      fill_in  page.all("input")[0]["id"], with: 5
      fill_in  page.all("input")[1]["id"], with: 5
      fill_in  page.all("input")[2]["id"], with: 5
      fill_in  page.all("input")[3]["id"], with: 5
      fill_in  page.all("input")[4]["id"], with: 5
      fill_in  page.all("input")[5]["id"], with: 5
      page.all("label")[1].click
      click_button "Save and continue"
      select "Started the applicant firm", from: page.find('select')["id"]
      page.all("label")[1].click
      page.all("label")[3].click
      page.all("label")[5].click
      page.all("label")[8].click
      click_button "Save and continue"
      page.all(".add-req-doc")[0].click
      click_button "Choose from document library"
      sleep 1
      page.all("#document_library_file_name")[0].click
      click_button "Associate"
      page.all(".add-req-doc")[0].click
      sleep 1
      page.all(".add-req-doc")[1].click
      click_button "Choose from document library"
      sleep 1
      page.all("#document_library_file_name")[0].click
      click_button "Associate"
      click_button "Save and continue"
      sleep 1
      click_button "Submit"
      click_link "Individual Contributors"
      click_link "Firm Owner Questionnaire"
      sleep 1

      fill_out_general_info_section
      fill_out_ownership_to_disadvantage

      should_have_page_content "8(a) Disadvantaged Individual section is complete"

      click_link "Character"
      page.all("label")[0].click
      page.all("label")[3].click
      page.all("label")[5].click
      page.all("label")[7].click
      click_button "Continue"
      click_button "Submit"
      should_have_page_content "Character section is complete"

      click_link "Potential for Success"
      add_generic_attachment
      click_button "Continue"
      page.all("label")[0].click
      page.all("label")[2].click
      fill_in  page.all("input")[0]["id"], with: 50
      add_generic_attachment
      click_button "Continue"
      page.all("label")[1].click
      page.all("label")[3].click
      page.all("label")[5].click
      click_button "Continue"
      click_button "Submit"
      should_have_page_content "Potential for Success section is complete"

      click_link "Control"
      page.all("label")[1].click
      page.all("label")[3].click
      page.all("label")[5].click
      page.all("label")[6].click
      add_generic_attachment
      page.all("label")[10].click
      page.all("label")[12].click
      click_button "Continue"
      click_button "Submit"
      should_have_page_content "8(a) Control Application section is complete"
      click_button "Sign and submit"

      page.find("label[for='legal_0']").click
      click_button "Accept"
      should_have_content "Your application has been submitted"
      click_link '8(a) Initial Application'
      click_link 'Basic Eligibility'
      should_have_content "General Assessment"
      click_link 'close'
      click_link 'Control'
      should_have_content "Firm Control"
    end

  end

end
