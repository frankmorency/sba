require 'feature_helper'

feature 'Am I Eligible' do
  scenario 'successfully completing the questionnaire', js: true do
    visit '/'
    click_link 'Am I eligible?'
    
    should_have_content 'Is there an SBA Contracting Program for me?', 'About your business', 'U.S. citizens?'
    click_button 'Yes', sleep: 0.2

    should_have_content 'unconditional and direct?'
    click_button 'Yes', sleep: 0.2
    
    should_have_content 'organized for profit?'
    click_button 'Yes', sleep: 0.2
    
    should_have_content 'debarred or suspended by any federal entity?'
    click_button 'Yes', sleep: 0.2
    
    should_have_content 'American products, materials or labors?'
    click_button 'Yes', sleep: 0.2
    
    should_have_content 'considered small'
    click_button 'Yes', sleep: 0.2
    
    should_have_content 'women', 'at least 51%'
    click_button 'Yes', sleep: 0.2

    should_have_content 'set-asides available in your primary NAICS code?'
    fill_in 'naics_code', with: '221310'
    click_button 'Find NAICS', sleep: 1

    should_have_content 'economically disadvantaged women under the guidelines'
    click_button 'Yes', sleep: 0.2

    should_have_content 'economically disadvantaged under 8'
    click_button 'Yes', sleep: 0.2

    should_have_content 'identify as one of the following?'
    click_button 'Yes', sleep: 0.2

    should_have_content 'experienced bias of a chronic and substantial nature?'
    click_button 'Yes', sleep: 0.2

    should_have_content 'previously been certified'
    click_button 'Yes', sleep: 0.2

    should_have_content 'previously used their one time'
    click_button 'Yes', sleep: 0.2

    should_have_content 'employees work located in a HUBZone?'
    click_button 'Yes', sleep: 0.2

    should_have_content 'employees reside in a HUBZone?'
    click_button 'Yes', sleep: 0.2

    sleep 1
    should_have_content 'you may be eligible for the HUBZone Program', 'you may be eligible for the EDWOSB program', 'you may be eligible for the WOSB Program'
    should_have_content 'you may not be eligible for the 8(a) BD Program'
  end
end
