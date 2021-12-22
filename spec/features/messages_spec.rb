require 'feature_helper'

feature 'Messages' do
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
    @master_application = nil
  end

  scenario 'workflow for vendor and analyst', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_8a_app_for @vendor_in_philly
      click_link '8(a) Initial Application'
      click_link 'Messages'
      _html = Nokogiri::HTML(body)
      _html.css('.usa-button-disabled').count == 1
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
      click_link "Messages"
      click_link "New Message"
      _html = Nokogiri::HTML(body)
      _html.css("#user_2 option").count == 2
      select 'Vendor Guy', from: 'user_2'
      @vendor_in_philly.deleted_at = Date.today
      @vendor_in_philly.save!
      page.refresh
      _html = Nokogiri::HTML(body)
      _html.css("#user_2 option").count == 1
      @vendor_in_philly.deleted_at = nil
      @vendor_in_philly.save!
    end

    as_user @vendor_in_philly  do
      visit("/")
      click_link '8(a) Initial Application'
      click_link 'Messages'
      click_link 'New Message'
      fill_in "subject", with: "Mike"
      page.find(".ql-editor").set("\tBody of Message")
      click_button "Send Message"
    end

  end
end
