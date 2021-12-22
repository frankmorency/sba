require 'feature_helper'

feature 'Claiming a business' do
  before do
    seed_claim_a_business
  end

  scenario 'for an existing, unassigned user claiming an unclaimed biz' do
    visit '/'
    click_button 'Login'
    fill_in 'User email', with: 'claim_jumper@mailinator.com'
    fill_in 'User password', with: 'password'
    click_button 'Sign-in'
    should_have_page_content 'Connect your SAM.gov data to Certify'

    fill_in 'DUNS Number', with: '595621168'
    fill_in 'TIN Number', with: '123456789'
    fill_in 'MPIN', with: 'A12345678'
    click_button 'Connect data'

    within('.business_search_result') do
      should_have_content 'Entity 372 Legal Business Name'
      select 'LLC', from: 'business_type'
      click_button 'Connect data'
    end

    expect(current_path).to eq('/vendor_admin/dashboard')
    should_have_page_content 'You have been successfully associated with the organization.'
  end
end

