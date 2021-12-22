require 'feature_helper'

feature 'Add Agency Requirement Organization' do
  before do   
    @user = create_user_sba_analyst    
    @agency_requirement = FactoryBot.create :agency_requirement 
    @organization1 = FactoryBot.create :organization
    @organization2 = FactoryBot.create :organization
  end

  scenario 'Happy Path, User successfully adds Agency Organization and cannnot add the same firm', js: true do 
    as_user @user do           
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}"
      page.all(".sba-c-icon--blue")[0].click
      click_link "Firms"
      fill_in "DUNS Number:", with: @organization1.duns_number
      click_button "Add firm"
      should_have_page_content "Success"      
      fill_in "DUNS Number:", with: @organization1.duns_number
      click_button "Add firm"
      should_have_page_content "Error"
    end
  end     
end
