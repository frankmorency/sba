require 'feature_helper'

feature 'MPP Application' do
  before do
    @vendor = create_user_vendor_admin
    as_user @vendor do
      visit '/'
      end
  end

  def complete_mpp()
      visit '/vendor_admin/my_certifications'
      page.execute_script("$('#certificate_type_mpp').click()")
      click_button 'Start a new application'
      click_button 'Accept'
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
      fill_in page.all("input")[1]["id"], with: "Testing"
      select "622110", from: page.all('select')[2]["id"]
      click_button "Save and continue"

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
      fill_out("textarea", 4, "Testing")
      click_button "Save and continue"

      # Financial Needs
      fill_out("textarea", 4, "Testing")
      click_button "Save and continue"

      # Contracting Needs
      fill_out("textarea", 4, "Testing")
      click_button "Save and continue"

      # Intl Trade Education Needs
      fill_out("textarea", 4, "Testing")
      click_button "Save and continue"

      # Business Development Needs
      fill_out("textarea", 4, "Testing")
      click_button "Save and continue"

      # General/Administrative Needs
      fill_out("textarea", 4, "Testing")
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

  def verify_mpp_application()
      visit '/vendor_admin/my_certifications'
      should_not_have_page_content "All Small Mentor-Protégé Program (Review requirements)"
      visit '/vendor_admin/dashboard'
      should_have_page_content "MPP Application"
      page.has_link? "MPP Application"
      expect(page).to have_link('MPP Application', count: 2)
  end

  scenario 'MPP Happy Path for two applications', js: true do
      # first application
      complete_mpp()
      # second application
      complete_mpp()
      # verify the status of the applications
      verify_mpp_application()

  end

  end