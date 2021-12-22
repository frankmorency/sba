require 'feature_helper'

feature '8(a) Request for Information' do
  before do
    @vendor_in_philly = create_user_vendor_admin
    @supervisor_8a_cods_in_philly = create_user_sba :sba_supervisor_8a_cods

    # when a user has an active cert
    @app = create_stubbed_8a_app_with_active_cert(@vendor_in_philly)
  end

  # scenario 'the analyst should be able to make a request for information' do
  #   login_as @supervisor_8a_cods_in_philly
  # 
  #   visit '/'
  #   click_link @vendor_in_philly.organization.name
  #   select 'Baltimore', from: 'field_office'
  #   click_button 'Set district office'
  #   # page.driver.browser.switch_to.alert.accept
  #   click_link @vendor_in_philly.organization.name
  #   click_link 'Request additional information outside of 8(a) Annual Review'
  #   should_have_heading 'Request additional information outside an 8(a) Annual Review'
  #   click_link 'Get started'
  #   should_have_heading 'Request for Information'
  #   fill_in 'Title', with: 'This is the title'
  #   fill_in 'Information requested', with: 'lots o info'
  #   within '#new_information_request' do
  #     check 'Text'
  #   end
  # 
  #   click_button 'Create questionnaire'
  # 
  #   within 'table#certifications' do
  #     should_have_content '8(a) Info Request', 'Draft'
  #   end
  # end
end

