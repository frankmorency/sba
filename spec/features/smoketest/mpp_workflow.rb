require 'feature_helper'

feature 'MPP Application Workflow' do
  before do
    @vendor_in_philly = create_user_vendor_admin
    @analyst_mpp =  create_user_sba :sba_supervisor_mpp
    @master_application = nil
  end

  def sort_application(type)
      page.find("div[aria-controls='a1']").click
      page.all('li').select { |element| element.text == "#{type}" }.first.click
      page.find('#mpp_sort').find(:xpath, 'option[6]').select_option
      sleep 5
      page.all('a').select {|linktext| linktext.text == "Da Biz" }.first.click
      sleep 2
  end

  def complete_mpp_determination(type)
    sort_application("#{type}")
    page.all('a').select {|linktext| linktext.text == "MPP Application" }.first.click
    click_button "Start"
    click_button "Save and commit"
    click_button "Save and commit"
    page.find('label[for=review_workflow_state_determination_made]').click
    page.find('#determination_decision').find(:xpath, 'option[2]').select_option
    click_button "Save and commit"
    page.find('h3', text: 'You are in view-only mode (Version #1)', match: :prefer_exact)
    page.find('p', text: 'You can view the vendor\'s record but can not make edits', match: :prefer_exact)

  end

  scenario 'Happy Path for MPP workflow', js: true do
    as_user @vendor_in_philly do
      @master_application = create_and_fill_mpp_for @vendor_in_philly
      @master_application = create_and_fill_mpp_for @vendor_in_philly
      @master_application = verify_mpp_application_submitted
      @master_application = verify_active_document_library
    end
    as_user @analyst_mpp do
       visit("/")
       visit 'sba_analyst/cases/mpp'
       complete_mpp_determination("No Review")
       visit 'sba_analyst/cases/mpp'
       complete_mpp_determination("No Review")
       visit 'sba_analyst/cases/mpp'
       sort_application("Determination Made")
      end

      within page.all("table#certifications").first do
        should_have_content 'MPP Application', 'Active', 'SBA Approved'
        expect(page).to have_link('MPP Application', count: 2)
      end
      sleep 5


    end
  end



