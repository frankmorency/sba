require 'feature_helper'

feature 'New Agency Requirement' do
  before do
    @user = create_user_sba_analyst
    @agency_requirement = FactoryBot.create :agency_requirement
    AgencyContractType.create!(name: "Sole")
  end

  scenario 'Happy Path, User successfully creates a new Agency Requirement with no Agency Contact, District Office, Agency Offer Code, Agency Offer Scope, Agency Offer Agreement, or Program Id. Contract Awarded is false by default', js: true do
    as_user @user do
      nil_values = ['agency_co_id', 'duty_station_id', 'program_id', 'agency_offer_code_id', 'agency_offer_scope_id', 'agency_offer_agreement_id', 'program_id']
      visit 'sba_analyst/agency_requirements/new'
      fill_in "Title(Required):", with: "Mike"
      page.find(".ui-button-text").click
      page.all(".ui-menu-item")[1].click
      select "Sole", from: "Type(Required):"
      click_button "Add requirement"
      should_have_content "Agency Requirement Mike successfully created"
      agency = AgencyRequirement.last
      nil_values.each do |x|
        agency[x].should == nil
      end
      agency.agency_office.name.should == "Administration Office, Executive Office of the President"
      agency.title.should == "Mike"
      agency['contract_awarded'].should == false
    end
  end

  scenario 'Happy Path, User successfully creates a new Agency Requirement with a valid Agency Contact', js: true do
    as_user @user do
      sleep 1
      visit 'sba_analyst/agency_requirements/new'
      fill_in "Title(Required):", with: "Mike"
      select "Connecticut", from: "District Office:"
      page.find(".ui-button-text").click
      page.all(".ui-menu-item")[1].click
      select "Sole", from: "Type(Required):"
      fill_in "Email:", with: "mike@test.com"
      fill_in "First Name:", with: "John"
      fill_in "Last Name:", with: "Doe"
      click_button "Add requirement"
      should_have_content "Agency Requirement Mike successfully created"
      agency_co = AgencyRequirement.last.agency_co
      agency_co.first_name.should == "John"
      agency_co.last_name.should == "Doe"
      agency_co.email.should == "mike@test.com"
    end
  end

  scenario 'Validation when User tries to  new Agency Requirement', js: true do
    as_user @user do
      visit 'sba_analyst/agency_requirements/new'
      click_button "Add requirement"
      should_have_content "This field is required."
    end
  end

  scenario 'District Office is added correctly', js: true do
    as_user @user do
      sleep 1
      visit 'sba_analyst/agency_requirements/new'
      fill_in "Title(Required):", with: "Mike"
      select "Connecticut", from: "District Office:"
      page.find(".ui-button-text").click
      page.all(".ui-menu-item")[1].click
      select "Sole", from: "Type(Required):"
      click_button "Add requirement"
      should_have_content "Agency Requirement Mike successfully created"
      agency = AgencyRequirement.last
      agency_co = agency.agency_co
      district_office = agency.duty_station
      district_office.name.should == "Connecticut"
    end
  end

end
