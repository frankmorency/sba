module QuestionnaireHelpers
  def should_have_heading(title, level = 'h1')
    expect(page).to have_selector(level, text: title)
  end

  def should_be_on_section(title)
    should_have_heading title, 'h2'
  end

  def answer_question(name, value)
    if %w(Yes No).include? value
      within("#answers_#{name}") do
        choose value, allow_label_click: true
      end
    end
  end

  def draft_and_fill_8a_app_for(vendor)
    login_as vendor

    visit '/certificate_types/eight_a/sba_applications/new?application_type_id=initial'
    page.find("input[class='accept_button']").click

    master_application = SbaApplication::MasterApplication.order(created_at: :desc).where(creator_id: vendor.id).first

    auto_fill_application_draft_up_to_general_information master_application
  end

  def create_and_fill_8a_app_on_local_for(vendor)
    visit 'http://localhost:3000/certificate_types/eight_a/sba_applications/new?application_type_id=initial'
    click_button 'Accept'
    master_application = SbaApplication::MasterApplication.order(created_at: :desc).where(creator_id: vendor.id).first
  end

  def create_and_fill_8a_app_for(vendor)
    login_as vendor

    visit '/certificate_types/eight_a/sba_applications/new?application_type_id=initial'
    click_button 'Accept'
    master_application = SbaApplication::MasterApplication.order(created_at: :desc).where(creator_id: vendor.id).first

    auto_fill_application master_application
    click_button 'Sign and submit'
    page.find('label[for=legal_0]').click
    click_button 'Accept'

    should_have_page_content 'Success', 'Your application has been submitted'
    within page.all("table#certifications").first do
      should_have_content '8(a) Initial Application', 'Pending', 'Certificate'
    end

    master_application
  end

  def auto_fill_application_draft_up_to_general_information(app)
    visit("/sba_applications/#{app.id}/fill")
    should_have_page_content 'Your app has been prepopulated - you can now go submit it'
    click_link '8(a) Initial Application'
    click_link 'Individual Contributors'
    click_link 'Firm Owner Questionnaire'

    current_path =~ /\/sba_applications\/(\d+)\//
    dvd_app = SbaApplication.find($1)
    fill_out_and_test_general_info_section
  end

  def fill_in_correct_address
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    address_1 = answer_ids[0].attributes["id"]
    address_2 = answer_ids[1].attributes["id"]
    zip_code =  answer_ids[2].attributes["id"]
    date_picker =  answer_ids[3].attributes["id"]
    select_inputs = _html.css("select")
    country_select = select_inputs[1].attributes["id"]
    state_select = select_inputs[0].attributes["id"]
    fill_in address_1, with: "123 Street"
    fill_in address_2, with: "Harpers Ferry"
    select( "Alabama", from:  state_select)
    fill_in zip_code, with: 25234
    click_button "Continue"
  end


  def fill_in_generic_dob
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    select_inputs = _html.css("select")
    date_of_birth = answer_ids[0].attributes["id"]
    place_of_birth = answer_ids[1].attributes["id"]
    country_of_birth = select_inputs[0].attributes["id"]
    select( "United States", from:  country_of_birth)
    fill_in place_of_birth, with: "DC"
    fill_in date_of_birth, with: "02/26/1979"
  end

  def auto_fill_application(app)
    case app
      when SbaApplication::MasterApplication
        visit("/sba_applications/#{app.id}/fill")
        should_have_page_content 'Your app has been prepopulated - you can now go submit it'

        within page.all("table#certifications").first do
          click_link '8(a) Initial Application'
        end

        click_link 'Individual Contributors'
        click_link 'Firm Owner Questionnaire'
        # click_button 'Accept'
        current_path =~ /\/sba_applications\/(\d+)\//
        dvd_app = SbaApplication.find($1)
        auto_fill_application(dvd_app)
      when SbaApplication::SubApplication
        visit("/sba_applications/#{app.id}/fill")
        should_have_page_content 'Your app has been prepopulated - you can now go submit it'
        within page.all("table#certifications").first do
          click_link '8(a) Initial Application'
        end
      when SbaApplication::SimpleApplication
        # use submit = true
    end
  end

  def auto_fill_application_local(app)
    case app
      when SbaApplication::MasterApplication
        visit("http://localhost:3000/sba_applications/#{app.id}/fill")
        should_have_page_content 'Your app has been prepopulated - you can now go submit it'

        within page.all("table#certifications").first do
          click_link '8(a) Initial Application'
        end

        click_link 'Individual Contributors'
        click_link 'Firm Owner Questionnaire'
        # click_button 'Accept'
        current_path =~ /\/sba_applications\/(\d+)\//
        dvd_app = SbaApplication.find($1)
        auto_fill_application(dvd_app)
      when SbaApplication::SubApplication
        visit("http://localhost:3000/sba_applications/#{app.id}/fill")
        should_have_page_content 'Your app has been prepopulated - you can now go submit it'
        within page.all("table#certifications").first do
          click_link '8(a) Initial Application'
        end
      when SbaApplication::SimpleApplication
        # use submit = true
    end
  end

  def save_and_continue
    click_button 'Save and continue'
  end

  def check_for_correct_errors
    _html = Nokogiri::HTML(body)
    errors = _html.css('form#questionnaire_form span.error')
    error_count = 0
    errors.each {|x| error_count+=1 if x.attributes["style"]&.value == "display: none;" ; }
    errors.count - error_count
  end

  def submit_and_check_for_correct_errors
    # page.find('#section_submit_button').click
    page.find('body').click
    click_button "Continue"
    _html = Nokogiri::HTML(body)
    errors = _html.css('form#questionnaire_form span.error')
    error_count = 0
    errors.each {|x| error_count+=1 if x.attributes["style"]&.value == "display: none;" ; }
    errors.count - error_count
  end

  def fill_out_general_info_section
    # Gender
    select "Male", from: page.find('select')["id"]
    click_button "Continue"

    # Marital Status
    page.all("label")[0].click
    click_button "Continue"

    # SSN
    click_button "Continue"
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[required='required']")[0].attributes["id"]
    fill_in answer_id, with: 1111111111

    #Phone Number / Contact Information
    click_button "Continue"
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[required='required']")[0].attributes["id"]
    fill_in answer_id, with: 1111111111
    click_button "Continue"

    #Current Home Address and Date of Residency
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    address_1 = answer_ids[0].attributes["id"]
    address_2 = answer_ids[1].attributes["id"]
    zip_code =  answer_ids[2].attributes["id"]
    date_picker =  answer_ids[3].attributes["id"]
    select_inputs = _html.css("select")
    country_select = select_inputs[1].attributes["id"]
    state_select = select_inputs[0].attributes["id"]
    fill_in address_1, with: "123 Street"
    fill_in address_2, with: "Harpers Ferry"
    select( "Alabama", from:  state_select)
    fill_in zip_code, with: 25234
    select( "United States", from:  country_select)
    #Date Picker
    fill_in date_picker, with: "02/26/2011"
    page.find('body').click
    click_button 'Continue'
    # Have you lived at your present address more than 10 years?
    answer_question :has_been_ten_years, "Yes"
    click_button 'Continue'

    # Date and Place of Birth
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    select_inputs = _html.css("select")
    date_of_birth = answer_ids[0].attributes["id"]
    place_of_birth = answer_ids[1].attributes["id"]
    country_of_birth = select_inputs[0].attributes["id"]
    fill_in place_of_birth, with: "DC"
    select( "United States", from:  country_of_birth)

    fill_in date_of_birth, with: "02/26/2011"
    click_button 'Continue'

    answer_question :eight_a_us_citizenship, "Yes"
    click_button 'Continue'

    add_generic_attachment
    click_button 'Continue'

  end

  def fill_out_and_test_general_info_section
    # Marital Status
    check_for_correct_errors.should == 0
    click_button "Continue"
    check_for_correct_errors.should == 1
    page.find('select').find(:xpath, 'option[3]').select_option
    click_button "Continue"
    check_for_correct_errors.should == 0
    click_button "Continue"
    check_for_correct_errors.should == 1
    page.all('label')[1].click
    click_button "Continue"
    check_for_correct_errors.should == 0
    # SSN
    _html = Nokogiri::HTML(body)
    check_for_correct_errors.should == 0
    click_button "Continue"
    check_for_correct_errors.should == 1
    answer_id = _html.css("input[required='required']")[0].attributes["id"]
    fill_in answer_id, with: 1111111111
    click_button "Continue"

    #Phone Number / Contact Information
    check_for_correct_errors.should == 0
    click_button "Continue"
    check_for_correct_errors.should == 1
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[required='required']")[0].attributes["id"]
    fill_in answer_id, with: 1111111111
    click_button "Continue"

    #Current Home Address and Date of Residency
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    address_1 = answer_ids[0].attributes["id"]
    address_2 = answer_ids[1].attributes["id"]
    zip_code =  answer_ids[2].attributes["id"]
    date_picker =  answer_ids[3].attributes["id"]
    select_inputs = _html.css("select")
    country_select = select_inputs[1].attributes["id"]
    state_select = select_inputs[0].attributes["id"]
    check_for_correct_errors.should == 0
    click_button "Continue"
    check_for_correct_errors.should == 5
    fill_in address_1, with: "123 Street"
    submit_and_check_for_correct_errors.should == 4
    fill_in address_2, with: "Harpers Ferry"
    submit_and_check_for_correct_errors.should == 3
    select( "Alabama", from:  state_select)
    submit_and_check_for_correct_errors.should == 2
    fill_in zip_code, with: 25234
    submit_and_check_for_correct_errors.should == 1

    page.refresh
    check_for_correct_errors.should == 0
    select( "United Kingdom", from:  country_select)
    submit_and_check_for_correct_errors.should == 3
    fill_in address_1, with: "123 Street"
    fill_in address_2, with: "123 City"
    submit_and_check_for_correct_errors.should == 1
    select( "United States", from:  country_select)
    fill_in date_picker, with: "02/04/20111"
    submit_and_check_for_correct_errors.should == 3
    fill_in zip_code, with: "12345"
    submit_and_check_for_correct_errors.should == 2
    select( "Alabama", from:  state_select)
    fill_in date_picker, with: "02/04/2011"
    submit_and_check_for_correct_errors.should == 0

    # Have you lived at your present address more than 10 years?
    answer_question :has_been_ten_years, "No"
    click_button 'Continue'
    # Date Range
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    address_1 = answer_ids[0].attributes["id"]
    address_2 = answer_ids[1].attributes["id"]
    zip_code =  answer_ids[2].attributes["id"]
    date_picker1 =  answer_ids[3].attributes["id"]
    date_picker2 =  answer_ids[4].attributes["id"]
    select_inputs = _html.css("select")
    country_select = select_inputs[1].attributes["id"]
    state_select = select_inputs[0].attributes["id"]
    select( "Alabama", from:  state_select)
    fill_in address_1, with: "123 Street"
    fill_in address_2, with: "123 City"
    fill_in zip_code, with: "12345"
    #DateRange Pickers
    fill_in date_picker2, with: "02/26/2015"
    fill_in date_picker1, with: "02/04/20111"
    submit_and_check_for_correct_errors.should == 2
    fill_in date_picker1, with: "02/30/2011"
    fill_in address_1, with: ""
    submit_and_check_for_correct_errors.should == 2
    fill_in date_picker1, with: "02/26/2016"
    fill_in date_picker2, with: "02/26/2015"
    submit_and_check_for_correct_errors.should == 3
    fill_in address_1, with: "213"
    fill_in date_picker1, with: "02/26/2014"
    fill_in date_picker2, with: "02/26/2017"

    submit_and_check_for_correct_errors.should == 0

    # Date and Place of Birth
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    select_inputs = _html.css("select")
    date_of_birth = answer_ids[0].attributes["id"]
    place_of_birth = answer_ids[1].attributes["id"]
    country_of_birth = select_inputs[0].attributes["id"]
    submit_and_check_for_correct_errors.should === 3

    fill_in place_of_birth, with: "DC"
    select( "United States", from:  country_of_birth)
    submit_and_check_for_correct_errors.should === 1

    fill_in date_of_birth, with: "02/04/20111"
    submit_and_check_for_correct_errors.should == 1
    fill_in date_of_birth, with: "2011/04/02"
    submit_and_check_for_correct_errors.should == 1
    fill_in date_of_birth, with: "02/30/2011"
    submit_and_check_for_correct_errors.should == 1
    fill_in date_of_birth, with: "02/26/2011"
    submit_and_check_for_correct_errors.should == 0

    answer_question :eight_a_us_citizenship, "Yes"
    click_button 'Continue'
    check_for_correct_errors.should == 0
    add_generic_attachment
    click_button 'Continue'

    fill_out_ownership_to_disadvantage
  end

  def fill_out_ownership_to_disadvantage
    # Ownership and Control Section
    # Applicant Firm Ownership
    _html = Nokogiri::HTML(body)
    answer_id = _html.css("input[required='required']")[0].attributes["id"]
    fill_in answer_id, with: 1
    answer_id2 = _html.css("textarea")[0].attributes["id"]
    fill_in answer_id2, with: "Bossman"
    click_button 'Continue'
    answer_question :eight_a_bank_account_access, 'No'
    click_button 'Continue'
    answer_question :eight_a_full_time_devotion, 'No'
    click_button 'Continue'
    answer_question :eight_a_business_affiliations, 'No'
    answer_question :eight_a_family_contractual_affiliation, 'No'
    click_button 'Continue'
    # Prior 8(a) Invovlement Section
    answer_question :eight_a_eligibility_q0, 'No'
    answer_question :eight_a_eligibility_q1, 'No'
    answer_question :eight_a_eligibility_q2, 'No'
    click_button 'Continue'

    # Federal Employment
    answer_question :eight_a_federal_employment_q0, 'No'
    click_button 'Continue'

    # Household Federal Employment
    answer_question :eight_a_household_federal_employment_q0, 'No'
    click_button 'Continue'

    # Character Section
    # Financial
    answer_question :eight_a_financial_q0, 'No'
    answer_question :eight_a_financial_q1, 'No'
    answer_question :eight_a_financial_q2, 'No'
    answer_question :eight_a_financial_q3, 'No'
    click_button 'Continue'

    # Criminal History
    answer_question :eight_a_criminal_history_q0, 'No'
    answer_question :eight_a_criminal_history_q1, 'No'
    answer_question :eight_a_criminal_history_q2, 'No'
    answer_question :eight_a_criminal_history_q3, 'No'
    click_button 'Continue'

    # Basis of Disadvantage Section
    # Basis of Disadvantage
    select "Black American", from: page.find('select')["id"]
    click_button 'Continue'

    # Economic Disadvantage Section
    # Transferred Assets
    answer_question :eight_a_asset_xfer, 'No'
    click_button 'Continue'

    add_generic_attachment
    click_button 'Continue'

    # Cash On Hand
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    date_picker =  answer_ids[0].attributes["id"]
    fill_in date_picker, with: "02/26/2011"
    fill_in  answer_ids[1].attributes["id"], with: 5
    fill_in  answer_ids[2].attributes["id"], with: 5
    fill_in  answer_ids[3].attributes["id"], with: 5
    click_button 'Continue'

    # Other Sources Of Income
    _html = Nokogiri::HTML(body)
    answer_ids = _html.css("input[aria-required='true']")
    fill_in  answer_ids[0].attributes["id"], with: 5
    fill_in  answer_ids[1].attributes["id"], with: 0
    fill_in  answer_ids[2].attributes["id"], with: 5
    fill_in  answer_ids[3].attributes["id"], with: 5
    click_button 'Continue'

    # Notes Receivable, DataTable is used if yes
    answer_question :notes_receivable, 'Yes'
    sleep 1
    page.find("a.new-record").click
    fill_in "DTE_Field_debtor_name", with: "Mike"
    fill_in "DTE_Field_debtor_address", with: "Mike"
    fill_in "DTE_Field_original_balance", with: 100
    fill_in "DTE_Field_current_balance", with: 40
    fill_in "DTE_Field_pay_amount", with: 40
    fill_in "DTE_Field_collateral_type", with: "Same"
    click_button 'Create'
    click_button 'Continue'

    # Retirement Accounts
    answer_question :roth_ira, 'Yes'
    sleep 1
    page.find("a.new-record").click
    fill_in "DTE_Field_total_value", with: 10
    fill_in "DTE_Field_contributions_thus_far", with: 5
    fill_in "DTE_Field_date_of_initial_contribution", with: "02/04/2011"
    fill_in "DTE_Field_investment_company", with: "Tysons"
    click_button 'Create'
    add_generic_attachment
    answer_question "other_retirement_accounts", "No"
    click_button 'Continue'

    # Life Insurance
    answer_question :life_insurance_cash_surrender, "No"
    answer_question :life_insurance_loans, "No"
    click_button 'Continue'

    # Stocks & Bonds
    answer_question :stocks_bonds, "No"
    click_button 'Continue'

    # Real Estate - Primary Residence
    answer_question :has_primary_real_estate, "No"
    click_button 'Continue'

    # Real Estate - Other
    answer_question :has_other_real_estate, "No"
    click_button 'Continue'

    # Personal Property
    answer_question :automobiles, "No"
    answer_question :other_personal_property, "No"
    click_button 'Continue'

    # Notes Payable and Other Liabilities
    answer_question :notes_payable, "No"
    click_button 'Continue'
    # Assessed Taxes
    answer_question :assessed_taxes, "No"
    click_button 'Continue'

    click_button 'Continue'
    click_button 'Continue'
    click_button 'Submit'
    page.driver.browser.switch_to.alert.accept
    page.find("label[for='legal_0']").click
    click_button 'Continue'
  end

  def add_generic_attachment
    click_link "Add documents"
    click_button "Choose from document library"
    sleep 1
    page.all("#document_library_file_name")[0].click
    click_button "Associate"
  end

  def fill_in_generic_note
    fill_in 'Title', with: 'You are closed'
    fill_in 'Note', with: 'closing it up'
    page.find('label', text: 'BOS Analysis').click
    click_button 'Next'
  end

  def fill_out(input_type, num, value)
    num.times do |x|
      fill_in page.all(input_type)[x]['id'], with: value
    end
  end

  def create_and_fill_mpp_for(vendor)
    login_as vendor
    visit '/vendor_admin/my_certifications'
    page.execute_script("$('#certificate_type_mpp').click()")
    click_button 'Start a new application'
    click_button 'Accept'
    master_application = SbaApplication::MasterApplication.order(created_at: :desc).where(creator_id: vendor.id).first
    page.all("label")[0].click
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
    within page.all("table#certifications").first do
      should_have_content 'MPP Application', 'Pending', 'Certificate'
    end
    master_application
  end

  def verify_mpp_application_submitted()
    visit '/vendor_admin/my_certifications'
    should_not_have_page_content "All Small Mentor-Protégé Program (Review requirements)"
    visit '/vendor_admin/dashboard'
    should_have_page_content "MPP Application"
    page.has_link? "MPP Application"
    expect(page).to have_link('MPP Application', count: 2)
    within page.all("table#manage").first do
      should_have_content 'qa_automation.pdf', 'Active'
    end
    page.find('a', text: 'My documents', match: :prefer_exact)
    page.all('a').select {|linktext| linktext.text == "My documents" }.first.click
  end

  def verify_active_document_library()
    visit '/vendor_admin/my_documents'
    within page.all("table#manage").first do
      should_have_content 'qa_automation.pdf', 'Third Party Certification'
    end
    page.find('a', text: 'Archived documents', match: :prefer_exact)
    page.all('a').select {|linktext| linktext.text == "Archived documents" }.first.click
    visit '/vendor_admin/my_documents/inactive'
    page.find('h1', text: 'My archived document library', match: :prefer_exact)
    page.find('a', text: 'Active documents', match: :prefer_exact)
    page.all('a').select {|linktext| linktext.text == "Active documents" }.first.click
  end

end