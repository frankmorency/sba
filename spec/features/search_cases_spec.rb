require 'feature_helper'

feature 'Search Case scenarios' do
  before do
    @user = create_user_sba_analyst
  end

  scenario '8(a)', js: true do
    as_user @user do
      visit 'sba_analyst/cases/eight_a'
      should_not_have_page_content 'Annual Review - screening'
      page.find("div[aria-controls='a1']").click
      page.find('label[for=eight_a_ar_screening]').click
      expect(page).to have_current_path(/eight_a%5Bar_screening%5D=0/)
      within '.sba-c-facet-pills' do
        should_have_content 'Annual Review - screening'
      end
      expect(page).to have_current_path(/eight_a%5Bar_screening%5D=ar_screening/)
      page.driver.browser.navigate.refresh
      expect(page).to have_current_path(/eight_a%5Bar_screening%5D=ar_screening/)
      fill_in_search_annual_review("eight_a")
      expect(page).to_not have_current_path(/eight_a%5Bar_screening%5D=ar_screening/)

      within '.sba-c-facet-pills' do
        should_not_have_content 'Annual Review - screening'
        should_have_content 'Annual Review - returned_with_deficiency_letter'
        should_have_content 'Annual Review - retained'
        should_have_content 'Adverse Action - early_graduation_recommended'
        should_have_content 'Adverse Action - termination_recommended'
        should_have_content 'Adverse Action - voluntary_withdrawal_recommended'
      end
      expect(page).to have_current_path(/eight_a%5Bar_returned_with_deficiency_letter%5D=ar_returned_with_deficiency_letter/)
      expect(page).to have_current_path(/eight_a%5Bar_processing%5D=ar_processing/)
      expect(page).to have_current_path(/eight_a%5Bar_retained%5D=ar_retained/)
      expect(page).to have_current_path(/eight_a%5Bar_early_graduation_recommended%5D=ar_early_graduation_recommended/)
      expect(page).to have_current_path(/eight_a%5Bar_termination_recommended%5D=ar_termination_recommended/)
      expect(page).to have_current_path(/eight_a%5Bar_voluntary_withdrawal_recommended%5D=ar_voluntary_withdrawal_recommended/)
      page.find("div[aria-controls='a2']").click
      fill_in_search_initial_application("eight_a")
      page.all(".sba-c-facet-pill") == 16
      page.find("div[aria-controls='a1']").click
      page.find("div[aria-controls='a2']").click
      click_link "Clear all"
      page.find('#eight_a_sba_office').find(:xpath, 'option[2]').select_option
      expect(page).to have_current_path(/eight_a%5Bsba_office%5D=Alabama/)
      should_have_content 'SBA Office - Alabama'
      page.find(".sba-c-facet-pill__close-button").click
      should_not_have_content 'SBA Office - Alabama'
      expect(page).to have_current_path(/eight_a%5Bsba_office%5D=/)
      test_fill_in_case_search_text_field("Search big", "Michael", 'Search - Michael', "eight_a%5Bsearch%5D=Michael")
      test_fill_in_case_search_text_field_with_pill("Case owner", "CaseOwnerExample", 'Case Owner - CaseOwnerExample', "eight_a%5Bcase_owner%5D=CaseOwnerExample")
      test_fill_in_case_search_text_field_with_pill("Servicing BOS", "BOSExample", 'BOS - BOSExample', "eight_a%5Bservice_bos%5D=BOSExample")
      page.find("label[for='eight_a_cs_pending']").click
      click_link "Clear all"
      URI.parse(current_url).request_uri.should == "/sba_analyst/cases/eight_a"
      page.find('#eight_a_sort').find(:xpath, 'option[4]').select_option
      fill_in("Search big", with: "Michael")
      fill_in("Case owner", with: "Michael")
      fill_in("Servicing BOS", with: "Michael")
      page.find('#eight_a_sba_office').find(:xpath, 'option[2]').select_option
    end
  end

  scenario 'MPP', js: true do
    as_user @user do
      visit 'sba_analyst/cases/mpp'
      should_not_have_page_content 'Annual Review - screening'
      test_fill_in_case_search_text_field("Search big", "Michael", 'Search - Michael', "mpp%5Bsearch%5D=Michael")
      test_fill_in_case_search_text_field_with_pill("Case owner", "CaseOwnerExample", 'Case Owner - CaseOwnerExample', "mpp%5Bcase_owner%5D=CaseOwnerExample")
      page.find("div[aria-controls='a1']").click
      page.find('label[for=mpp_ia_assigned_in_progress]').click
      page.all(".sba-c-facet-pill").count == 1
      page.find('label[for=mpp_ia_assigned_in_progress]').click
      page.find('label[for=mpp_ia_recommend_eligible]').click
      page.find('label[for=mpp_ia_recommend_ineligible]').click
      page.find('label[for=mpp_ia_determination_made]').click
      page.all(".sba-c-facet-pill").count == 3
      page.driver.browser.navigate.refresh
      page.all(".sba-c-facet-pill").count == 3
      page.find('label[for=mpp_cs_pending]').click
      page.find('label[for=mpp_cs_active]').click
      page.all(".sba-c-facet-pill").count == 5
      page.driver.browser.navigate.refresh
      page.all(".sba-c-facet-pill").count == 5
      page.find('label[for=mpp_ia_no_review]').click
      page.all(".sba-c-facet-pill").count == 6
      click_link "Clear all"
      page.all(".sba-c-facet-pill").count == 0
    end
  end

  scenario 'Wosb', js: true do
    as_user @user do
      visit 'sba_analyst/cases/wosb'
      test_fill_in_case_search_text_field("Search big", "Michael", 'Search - Michael', "wosb%5Bsearch%5D=Michael")
      test_fill_in_case_search_text_field_with_pill("Case owner", "CaseOwnerExample", 'Case Owner - CaseOwnerExample', "wosb%5Bcase_owner%5D=CaseOwnerExample")
      page.find('label[for=wosb_edwosb]').click
      page.all(".sba-c-facet-pill").count == 1
      page.driver.browser.navigate.refresh
      page.find('label[for=wosb_wosb]').click
      page.all(".sba-c-facet-pill").count == 2
      click_link "Clear all"
      page.all(".sba-c-facet-pill").count == 0
      page.find('label[for=wosb_edwosb]').click
      page.find('label[for=wosb_wosb]').click
      page.find('#wosb_sort').find(:xpath, 'option[3]').select_option
      page.fill_in("Search big", with: "Michael")
      page.fill_in("Search big", with: "Michael")
      within ".usa-search-big" do
        page.find("button").click
      end
      page.all(".sba-c-facet-pill").count == 5
      page.driver.browser.navigate.refresh
      page.all(".sba-c-facet-pill").count == 5
    end
  end
end
