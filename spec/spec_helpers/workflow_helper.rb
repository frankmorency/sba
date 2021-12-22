module WorkflowHelpers
  def make_determination(reconsider, reconsideration)
    click_button 'Actions'
    click_link 'Make determination'
    page.find("label[for='#{reconsider}']").click
    page.find("label[for='#{reconsideration}']").click
    click_button 'Next'
    click_button 'Next'
    # Select director
    page.find('label').click
    click_button 'Next'
    fill_in 'Title', with: 'You are closed'
    fill_in 'Note', with: 'closing it up'
    page.find('label', text: 'BOS Analysis').click
    click_button 'Next'
    fill_in 'Subject', with: 'You are closed'
    page.find(".ql-editor").set("\tBody of Message")
    click_button 'Next'
    click_button 'Save and continue'
    # if
    # should_have_content 'has been determined Ineligible'
  end

  def assign_district_office(office)
    select office, from: 'field_office'
    click_button 'Set District Office'
    page.driver.browser.switch_to.alert.accept
    should_have_content 'Success', 'The district office has been updated'
  end

  def begin_processing_the_case(organization_name)
    click_button 'Actions'
    click_link 'Begin processing this case'
    should_have_heading 'Accept this case for processing?'
    click_button 'Yes, accept for processing'
    page.driver.browser.switch_to.alert.accept
    should_have_heading "#{organization_name} Application was accepted for processing"
  end

  def enter_and_verify_initial_sba_note()
    # Enter and create SBA Notes
    page.find('#note-main-popup').click
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[type='text']")[0].attributes["id"]
    fill_in answer_id, with: "SBA Note Initial"
    answer_id2 = _html.css("textarea")[0].attributes["id"]
    fill_in answer_id2, with: "SBA Note Text area"
    page.find("label[for='note-tag--bos-analysis']").click
    page.find("label[for='note-tag--character']").click
    page.find("label[for='note-tag--eligibility']").click
    page.find("label[for='note-tag--ownership']").click
    page.find("label[for='note-tag--control']").click
    page.find("label[for='note-tag--potential-for-success']").click
    click_button 'Add SBA note'
    should_have_heading "Note added!", 'h4'

    # Verify SBA Notes that are created
    click_link 'SBA Notes'
    should_have_heading "SBA Note Initial", 'h3'
    should_have_heading "SBA Note Text area", 'p'
    should_have_heading "Tags:", 'strong'
    should_have_heading "BOS Analysis", 'span'
    should_have_heading "Control", 'span'
    should_have_heading "Character", 'span'
    should_have_heading "Eligibility", 'span'
    should_have_heading "Ownership", 'span'
    should_have_heading "Potential for Success", 'span'
  end

  def enter_and_verify_annual_sba_note()
    # Enter and create SBA Notes
    page.find('#note-main-popup').click
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[type='text']")[0].attributes["id"]
    fill_in answer_id, with: "SBA Note Annual Review"
    answer_id2 = _html.css("textarea")[0].attributes["id"]
    fill_in answer_id2, with: "SBA Note Text area Annual Review"
    page.find("label[for='note-tag--bos-analysis']").click
    page.find("label[for='note-tag--adverse-action']").click
    page.find("label[for='note-tag--business-development']").click
    page.find("label[for='note-tag--ownership']").click
    page.find("label[for='note-tag--control']").click
    page.find("label[for='note-tag--eligibility']").click
    page.find("label[for='note-tag--letter-of-intent']").click
    page.find("label[for='note-tag--retain-firm']").click
    page.find("label[for='note-tag--review-complete']").click

    # Verify SBA Notes that are created
    click_button 'Add SBA note'
    should_have_heading "Note added!", 'h4'
    click_link 'SBA Notes'
    should_have_heading "SBA Note Annual Review", 'h3'
    should_have_heading "SBA Note Text area Annual Review", 'p'
    should_have_heading "Tags:", 'strong'
    should_have_heading "BOS Analysis", 'span'
    should_have_heading "Control", 'span'
    should_have_heading "Eligibility", 'span'
    should_have_heading "Ownership", 'span'
    should_have_heading "Retain Firm", 'span'
    should_have_heading "Business Development", 'span'
    should_have_heading "Adverse Action", 'span'
    should_have_heading "Letter of Intent", 'span'
    should_have_heading "Review Complete", 'span'

  end

  def sba_note_8a_initial()
    # Create SBA Notes from Funbar Actions
    click_button 'Actions'
    click_link 'Add a note'
    enter_and_verify_initial_sba_note()
  end

  def sba_note_8a_annual_review()
    # Create SBA Notes from Funbar Actions
    click_button 'Actions'
    click_link 'Add a note'
    enter_and_verify_annual_sba_note()
  end

  def compose_initial_sba_note()
    # Create SBA Notes from SBA Notes Tab
    page.find('#compose-note-button').click
    enter_and_verify_initial_sba_note()
  end

  def compose_annual_sba_note()
    # Create SBA Notes from SBA Notes Tab
    page.find('#compose-note-button').click
    enter_and_verify_annual_sba_note()
  end

  def make_recommendation(reconsider, reconsideration)
    click_button 'Actions'
    click_link 'Make recommendation'
    should_have_heading 'Make a Recommendation'
    page.find("label[for='#{reconsider}']").click
    page.find("label[for='#{reconsideration}']").click if !reconsideration.nil?
    click_button 'Next'
    click_button 'Next' # don't upload any docs
    # select director
    page.find('label').click
    click_button 'Next'
    @vendor_in_philly.organization.certificates[0].workflow_state == 'pending'
    click_button 'Complete recommendation'
    should_have_content 'Recommendation Submitted'
    @vendor_in_philly.organization.certificates[0].current_review.workflow_state == 'processing'
  end

  def fill_out_wosb
    visit "vendor_admin/dashboard"
    click_link "WOSB self-certification"
    click_button "Accept"
    page.all("label")[0].click
    add_generic_attachment
    click_button "Continue"
    click_button "Submit"
    page.driver.browser.switch_to.alert.accept
    page.all("label")[0].click
    page.all("label")[1].click
    page.all("label")[2].click
    page.all("label")[3].click
    page.all("label")[4].click
    page.all("label")[5].click
    click_button "Continue"
    should_have_page_content "Your application has been submitted"
  end

  def fill_out_mentor
    visit "vendor_admin/dashboard"
    click_link "All Small Business Mentor-Protégé agreement"
    click_button "Accept"
    page.all("label")[1].click
    click_button "Save and continue"
    page.all("label")[0].click
    page.all("label")[2].click
    page.all("label")[5].click
    page.all("label")[7].click
    click_button "Save and continue"
    select "622110", from: page.find('select')["id"]
    page.all("label")[0].click
    page.all("label")[2].click
    click_button "Save and continue"
    page.all("label")[1].click
    click_button "Save and continue"
    add_generic_attachment
    click_button "Save and continue"
    add_generic_attachment
    page.all("label")[0].click
    click_button "Save and continue"
    page.find("#add_item").click
    sleep 1
    select "Mentor", from: page.all('select')[0]["id"]
    select "Department of Defense", from: page.all('select')[1]["id"]
    fill_in page.find(".hasDatepicker")['id'], with: "02/02/2016"
    fill_in page.all("input")[1]["id"], with: "MikeIsCool"
    select "622110", from: page.all('select')[2]["id"]
    click_button "Save and continue"

    # Active Agreement Documents and Additional Documents
    add_generic_attachment
    click_button "Save and continue"
    add_generic_attachment
    click_button "Save and continue"
    page.all("label")[0].click
    page.all("label")[2].click
    page.all("label")[4].click
    page.all("label")[6].click
    page.all("label")[8].click
    page.all("label")[10].click
    click_button "Save and continue"

    # Management/Technical Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # Financial Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # Contracting Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # Intl Trade Education Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # Business Development Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # General/Administrative Needs
    fill_out("textarea", 4, "HelloMikee")
    click_button "Save and continue"

    # Training
    add_generic_attachment
    click_button "Save and continue"

    # Confirm DUNS
    fill_in page.all('input')[0]['id'], with: Organization.last.duns_number
    click_link "Confirm DUNS"
    click_link "Confirm DUNS"
    sleep 1
    page.driver.browser.switch_to.alert.accept
    click_button "Save and continue"

    click_button "Submit"
    page.driver.browser.switch_to.alert.accept

    page.all("label")[0].click
    page.all("label")[1].click
    page.all("label")[2].click
    page.all("label")[3].click
    page.all("label")[4].click
    page.all("label")[5].click
    click_button "Accept"
    should_have_page_content "Your application has been submitted"
  end
end