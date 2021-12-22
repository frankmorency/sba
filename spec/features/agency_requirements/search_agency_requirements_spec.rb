require 'feature_helper'

feature 'Search Agency Requirement' do
  before do  	
    @user = create_user_sba_analyst    
    @agency_requirement = FactoryBot.create :agency_requirement
  end

  scenario 'Search UI', js: true do 
    as_user @user do              
      visit "sba_analyst/agency_requirements_search"      
      page.all("#pill-requirement_sba_office").count.should == 0
      page.all(".sba-c-facet-pill") == 0
      select "Alabama", from: "SBA Offices"
      page.has_css?('#pill-requirement_sba_office').should == true
      select "Dallas", from: "SBA Offices"
      page.has_css?('#pill-requirement_sba_office').should == true
      page.all("#pill-requirement_sba_office").count.should == 1      
      page.all(".sba-c-facet-pill") == 1
      select "Competitive", from: "Contract Type"
      page.has_css?('#pill-requirement_contract_type').should == true
      page.all(".sba-c-facet-pill") == 2
      select "Sole-Source", from: "Contract Type"  
      within '#search-breadcrumb-pills' do      
        should_not_have_content 'Competitive'   
        should_have_content 'Dallas'   
        should_have_content 'Sole-Source'           
      end
      sleep 1
      page.driver.browser.navigate.refresh            
      expect(find_field('SBA Offices').value).to eq 'Dallas'
      sleep 1
      within '#search-breadcrumb-pills' do      
        should_not_have_content 'Competitive'   
        should_have_content 'Dallas'   
        should_have_content 'Sole-Source'           
      end   
      page.find(".ui-button-text").click
      page.all(".ui-menu-item")[3].click
      page.has_css?('#pill-requirement_agency').should == true
      select "Void Duplicate", from: "Code"
      page.all(".sba-c-facet-pill") == 5
      click_link "Clear all"
      page.all(".sba-c-facet-pill") == 0
    end
  end  

end
