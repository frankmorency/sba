require 'feature_helper'

feature 'SmokeTest' do
  before do
    @vendor_in_philly = create_user_vendor_admin
    @supervisor_8a_cods_in_philly = create_user_sba :sba_supervisor_8a_cods
    @director = create_user_sba :sba_supervisor_8a_hq_program
    @director.roles_map = {"HQ_PROGRAM" => {"8a" => ["supervisor"]}}
    @director.save!
    @aa = create_user_sba :sba_supervisor_8a_hq_aa
    @aa.roles_map = {"HQ_AA" => {"8a" => ["supervisor"]}}
    @aa.save!
    @district_supervisor = create_user_sba :sba_supervisor_8a_district_office
    @district_supervisor.roles_map = {"DISTRICT_OFFICE" => {"8a" => ["supervisor"]}}
    @district_supervisor.save!
    @analyst_mpp = create_user_sba :sba_supervisor_mpp
    @analyst_mpp.roles_map = {"Legacy" => {"MPP" => ["analyst"]}}
    @analyst_mpp.save!
    @sba_analyst_cods = create_user_sba :sba_analyst_cods
    @sba_analyst_cods.roles_map = {"CODS" => {"8a" => ["analyst"]}}
    @sba_analyst_cods.save!
    @district_director = create_user_sba :sba_director_8a_district_office
    @district_director.roles_map = {"DISTRICT_OFFICE_DIRECTOR" => {"8a" => ["supervisor"]}}
    @district_director.save!
    @district_deputy_director = create_user_sba :sba_deputy_director_8a_district_office
    @district_deputy_director.roles_map = {"DISTRICT_OFFICE_DEPUTY_DIRECTOR" => {"8a" => ["supervisor"]}}
    @district_deputy_director.save!
    @master_application = nil
  end

  def actual_login(type)
    @users.each do |user|
      as_user user[type.to_i] do
        visit('/')
        sleep 5
      end
    end
  end

  def error_not_authorized()
    page.find('h3', text: 'Error', match: :prefer_exact)
    page.find('p', text: 'You are not authorized to perform this action.', match: :prefer_exact)
  end


  def verify_presence()
   # visit 'eight_a_initial_sba_analyst/dashboard'
   #  page.find('h1', text: 'Dashboard', match: :prefer_exact)
   #  page.find('h2', text: 'My Current Workload', match: :prefer_exact)

    visit 'sba_analyst/cases'
    page.find('h1', text: 'All cases', match: :prefer_exact)

    visit 'sba_analyst/agency_requirements/new'
    page.find('h3', text: 'Add New Requirement(s)', match: :prefer_exact)

    visit 'sba_analyst/agency_requirements_search'
    page.find('h1', text: 'All requirements', match: :prefer_exact)

    visit 'eight_a_initial_sba_analyst/dashboard#'

    visit 'sba_analyst/cases/eight_a'
    page.find('h1', text: '8(a) cases', match: :prefer_exact)

    visit 'sba_analyst/cases/mpp'
    page.find('h1', text: 'ASMPP cases', match: :prefer_exact)

    visit 'sba_analyst/cases/wosb'
    page.find('h1', text: 'WOSB cases', match: :prefer_exact)
  #   visit 'entity_owned'
  #   error_not_authorized()
  #    visit 'vendor_admin/dashboard'
  #    visit 'eight_a_initial_sba_analyst/dashboard'
  #    error_not_authorized()
  end

  def verify_vendor_absence()
    visit 'sba_analyst/cases/eight_a'
    error_not_authorized()
    visit 'sba_analyst/cases/mpp'
    error_not_authorized()
    visit 'sba_analyst/cases/wosb'
    error_not_authorized()
  end

  def user_login(type)
    case type

    when "@sba_analyst_cods"
      actual_login(0)
      puts "Login as SBA Analyst is successful"
      #any analyst verification methods for smoke test
      verify_presence()

    when "@vendor_in_philly"
      actual_login(1)
      puts "Login as Vendor is successful"
      #any vendor verification methods for smoke test
      verify_vendor_absence()

    when "@supervisor_8a_cods_in_philly"
      actual_login(2)
      puts "Login as SBA Supervisor is successful"
      visit 'sba_analyst/cases/mpp'
      #any supervisor verification methods for smoke test
      verify_presence()

    when "@aa"
      actual_login(3)
      puts "Login as SBA HQ_AA is successful"
      #any aa verification methods for smoke test
      verify_presence()

    when "@director"
      actual_login(4)
      puts "Login as SBA Director is successful"
      #any director verification methods for smoke test
      verify_presence()

    when "@district_supervisor"
      actual_login(5)
      puts "Login as SBA district supervisor is successful"
      #any district supervisor verification methods for smoke test
      verify_presence()

    when "@analyst_mpp"
      actual_login(6)
      puts "Login as SBA MPP Analyst is successful"
      visit 'sba_analyst/cases/mpp'
      #any analyst_mpp verification methods for smoke test
      verify_presence()
      
    when "@district_director"
      actual_login(7)
      puts "Login as SBA district director is successful"
      #any district deputy director verification methods for smoke test
      verify_presence()

    when "@district_director"
      actual_login(8)
      puts "Login as SBA deputy district director is successful"
      #any district deputy director verification methods for smoke test
      verify_presence()


    else
      raise "Warning >> Error with the login profile related to " + "#{type}".to_s

    end
  end

  #1 Login and view dasboard as all profiles
  scenario 'Login and view dasboard as all profiles', js: true do
    ##NOTE: all new users need to be added after the @analyst_mpp in the @users array
    @users = [
        [@sba_analyst_cods,
         @vendor_in_philly,
         @supervisor_8a_cods_in_philly,
         @aa,
         @director,
         @district_supervisor,
         @analyst_mpp]
    ]
    user_login("@sba_analyst_cods")
    user_login("@supervisor_8a_cods_in_philly")
    user_login("@vendor_in_philly")
    user_login("@aa")
    user_login("@director")
    user_login("@district_supervisor")
    user_login("@analyst_mpp")

  end

  #2 Eight 8 Flow
  scenario 'fill out new 8a, and test overview ajax calls', js: true do
    as_user @vendor_in_philly do
      login_as @vendor_in_philly
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
      fill_in page.all("input")[0]["id"], with: 5
      fill_in page.all("input")[1]["id"], with: 5
      fill_in page.all("input")[2]["id"], with: 5
      fill_in page.all("input")[3]["id"], with: 5
      fill_in page.all("input")[4]["id"], with: 5
      fill_in page.all("input")[5]["id"], with: 5
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
      fill_in page.all("input")[0]["id"], with: 50
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

  #3 WOSB Flow
  scenario 'fill out new WOSB', js: true do
    as_user @vendor_in_philly do
      login_as @vendor_in_philly
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

  end
end