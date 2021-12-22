require 'feature_helper'

feature  'Check if vendor organization is ' do
  before do
    @vendor = create_user_vendor_admin
    @org = @vendor.organization
    @org.entity_owned = nil
    @org.save!
  end

  skip 'Existing vendor signs in, is redirected to entity owned question, and enters yes', js: true do
    as_user @vendor do
      @vendor.organization.entity_owned.should == nil
      visit("/")
      should_have_content "Before you continue, please carefully answer this question."
      page.all(".sba-c-label")[0].click
      click_button "Submit"
      should_have_content "Welcome to your certify.SBA.gov dashboard. You have successfully connected your business from SAM.gov."
      @vendor.organization.entity_owned.should == true
    end
    as_user @vendor do
      visit("/")
      should_have_content "Welcome to your certify.SBA.gov dashboard. You have successfully connected your business from SAM.gov."
      @vendor.organization.entity_owned.should == true
    end
  end

  skip 'Existing vendor signs in, is redirected to entity owned question, and enters no', js: true do
    as_user @vendor do
      @vendor.organization.entity_owned.should == nil
      visit("/")
      should_have_content "Before you continue, please carefully answer this question."
      page.all(".sba-c-label")[1].click
      click_button "Submit"
      should_have_content "Welcome to your certify.SBA.gov dashboard. You have successfully connected your business from SAM.gov."
      @vendor.organization.entity_owned.should == false
    end
    as_user @vendor do
      visit("/")
      should_have_content "Welcome to your certify.SBA.gov dashboard. You have successfully connected your business from SAM.gov."
      @vendor.organization.entity_owned.should == false
    end
  end

end
