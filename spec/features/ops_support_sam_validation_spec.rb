require 'feature_helper'

feature 'Ops Support Workflow' do
  before do
    @ops_support_staff = create(:ops_support_staff_user)
    ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations(duns, tax_identifier_number, tax_identifier_type, mpin, sam_extract_code) VALUES ('111292429', '123456789', 'SSN', 'AP98645', 'A');")
    MvwSamOrganization.refresh
    @sam_org = MvwSamOrganization.first
  end

  scenario 'Fills out the SAM Data Validation Form', js: true do
    as_user @ops_support_staff do
      #visit the home page
      visit ('/')
      should_have_page_content 'Other Support Actions'
      click_link 'SAM Data Validation'
      #happy path
      fill_in 'DUNS', with: @sam_org.duns
      fill_in 'MPIN', with: @sam_org.mpin
      fill_in 'TIN', with: @sam_org.tax_identifier_number
      click_button 'Validate'
      should_have_page_content 'Exact match'
      #SAM Org does not exist for DUNS provided
      click_link 'Go back to validate SAM data'
      should_have_page_content 'Validate SAM Data'
      fill_in 'DUNS', with: '111111111111'
      fill_in 'MPIN', with: 'aaaaaaaaaa'
      fill_in 'TIN', with: '123456789'
      click_button 'Validate'
      should_have_page_content 'Could not find organization'
      #SAM Org exists but the TIN and MPIN are wrong
      click_link 'Go back to validate SAM data'
      should_have_page_content 'Validate SAM Data'
      fill_in 'DUNS', with:  @sam_org.duns
      fill_in 'MPIN', with: 'aaaaaaaaaa'
      fill_in 'TIN', with: '123456789'
      click_button 'Validate'
      should_have_page_content 'Incorrect'
      #SAM Org exists, the TIN is accurate but MPIN is in the wrong case
      click_link 'Go back to validate SAM data'
      should_have_page_content 'Validate SAM Data'
      fill_in 'DUNS', with:  @sam_org.duns
      fill_in 'MPIN', with: @sam_org.mpin.downcase
      fill_in 'TIN', with: '@sam_org.tax_identifier_number'
      click_button 'Validate'
      should_have_page_content 'Mismatch due to letter case'
    end
  end
end