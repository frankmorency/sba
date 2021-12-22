require 'feature_helper'

feature 'Show Agency Requirement' do
  before do   
    @user = create_user_sba_analyst       
    @agency_requirement_organization = FactoryBot.create :agency_requirement_organization 
    @agency_requirement = @agency_requirement_organization.agency_requirement    
  end

  scenario 'Happy Path, User sees Agency Organization', js: true do     
    as_user @user do
      visit "sba_analyst/agency_requirements/#{@agency_requirement.id}"            
      current_path.should == "/sba_analyst/agency_requirements/#{@agency_requirement.id}"      
      page.all(".sba-c-icon--blue")[0].click
      current_path.should == "/sba_analyst/agency_requirements/#{@agency_requirement.id}/edit"
    end
  end  

end
