require 'feature_helper'

feature 'User Accounts' do
  scenario 'Government user trying to create a new account', js: true do
    visit '/'
    click_link 'Federal government employees: Login or create an account'

    should_have_page_content 'Use MAX.gov to access certify'

    click_link 'Create an account on MAX.gov', sleep: 1

    should_open_url_in_new_tab 'https://portal.max.gov/portal/main/displayRegistrationForm'
  end

  # Captcha properly prevents test from working
  pending 'Non-gov user trying to create a new account' do
    visit '/'
    click_button 'Get started', sleep: 1

    should_have_page_content 'Create certify.SBA.gov Account'

    fill_in 'First Name', with: 'Max'
    fill_in 'Last Name', with: 'Headroom'
    fill_in 'Email Address', with: 'maxheadroom@mailinator.com'
    fill_in 'Confirm Email Address', with: 'maxheadroom@mailinator.com'
    click_button 'Continue', sleep: 1

    should_have_page_content 'Create Password'

    fill_in 'Password', with: 'areallylongwordyoneyoudig'
    fill_in 'Confirm Password', with: 'areallylongwordyoneyoudig'
    page.find(:css, '#accept_terms', visible: false).set(true)
    page.find(:css, '#g-recaptcha-response', visible: false).set('fake-recaptcha')
    check 'accept_terms'
    click_button 'Create account', sleep: 1

    should_have_page_content 'You will receive an email with a verification link at maxheadroom@mailinator.com in the next 48 hours'
  end

  scenario 'Password reset: invalid email address' do
    visit '/'
    click_button 'Login'
    click_link 'Forgot your password?'
    fill_in 'Email', with: 'maxheadroom@mailinator.com'
    click_button 'Send the instructions'
    should_have_page_content 'Email not found'
  end
end
