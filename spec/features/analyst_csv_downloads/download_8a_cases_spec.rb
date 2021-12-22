require 'feature_helper'

feature '8(a) Download Cases' do
  before do
    @program_sba_analyst = create_user_sba_analyst
    @program_sba_analyst.roles_map = {"HQ_PROGRAM"=>{"8a"=>["analyst"]}}
    @program_sba_analyst.save!
    @vendor = create_user_vendor_admin
  end
  
  xscenario 'Download Case', js: true do
    as_user @vendor do
      @master_application = create_and_fill_8a_app_for @vendor
    end

    as_user @program_sba_analyst do
      visit("/")

      # should see the case on their dashboard
      within('table#unassigned_cases') do
        should_have_content 'Initial', 'Assign', @vendor.organization.name
        click_link 'Assign'        
      end
      
      visit("/")
      click_Link 'Download CSV of current page'
      wait_for_download
      expect(downloads.length).to eq(1)
      expect(download).to match(/.*\.csv/)  
    end  
  end  
end
