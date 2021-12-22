require 'feature_helper'

feature 'Edit Agency Requirement' do
  before do  	
    @user = create_user_sba_analyst    
    @agency_requirement = FactoryBot.create :agency_requirement            
  end

  scenario 'Happy Path, User successfully adds Agency Contact', js: true do 
    as_user @user do                     
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
      fill_in "First Name:", with: "Michael"
      fill_in "Last Name:", with: "George"
      fill_in "Email:", with: "mike@mike.com"      
      click_button "Update requirement"
      agency_requirement = AgencyRequirement.last
      agency_requirement.agency_co.first_name.should == "Michael"
      agency_requirement.agency_co.last_name.should == "George"
      agency_requirement.agency_co.email.should == "mike@mike.com"      
      current_path.should == "/sba_analyst/agency_requirements/#{@agency_requirement.id}"
      should_have_page_content "mike@mike.com"          
    end
  end  

  scenario 'User only includes first name and does not add an Agency Contact, and stays on the edit page', js: true do 
    as_user @user do                     
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
      fill_in "First Name:", with: "Michael"  
      click_button "Update requirement"
      agency_requirement = AgencyRequirement.last
      agency_requirement.agency_co.should == nil            
      should_have_page_content "Last name can't be blank"
      current_path.should == "/sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
    end
  end  

  scenario 'User only includes first name and does not add an Agency Contact', js: true do 
    as_user @user do
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
      fill_in "First Name:", with: "Michael"
      fill_in "Last Name:", with: "George"
      fill_in "Email:", with: "mike@mike.com"
      click_button "Update requirement"
      agency_requirement = AgencyRequirement.last
      agency_requirement.agency_co.first_name.should == "Michael"
      agency_requirement.agency_co.last_name.should == "George"
      agency_requirement.agency_co.email.should == "mike@mike.com"
      current_path.should == "/sba_analyst/agency_requirements/#{@agency_requirement.id}"
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
      expect(find_field('First Name:').value).to eq 'Michael'
      expect(find_field('Last Name:').value).to eq 'George'
      expect(find_field('Email:').value).to eq 'mike@mike.com'
      fill_in "First Name:", with: ""
      fill_in "Phone:", with: "3233233232"
      click_button "Update requirement"
      expect(find_field('First Name:').value).to eq 'Michael'
      expect(find_field('Phone:').value).to eq ''
      should_have_page_content "First name can't be blank"
    end
  end    

end
