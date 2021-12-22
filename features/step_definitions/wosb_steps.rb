require 'watir'

When("the vendor starts an application for the {string} program") do |string|
  case string
  when "WOSB"
    on(WelcomePage).wosb.wait_until_present(timeout: 30).click
    on(WelcomePage).accept_button_8a.wait_until_present(timeout: 30).click
  end
end


When("the vendor completes the simple {string} application") do |string|
  case string
  when "WOSB"
    on(WosbApplication).eight_a_section(string, "8a")
    on(WosbApplication).eight_a_section(string, "Review Submit")
  end
end

Then("the vendor gets self-certified in {string} program") do |string|
  case string
  when "WOSB"
    on(WelcomePage).active_wosb_application
    on(WelcomePage).view_summary
    on(WosbApplication).view_certificate_letter
    on(LoginPage).account()
    on(LoginPage).logout()
  end
end

Then ("view {string} cases pre-filtered on All Cases Page") do |string|
  case string
  when "WOSB"
    on(CasesPage).wosb_cases
    on(CasesPage).link_to_firm_overview
  end
end

Then ("search for a business by its DUNS number and view its applications") do
  on(CasesPage).goto_cases
  on(CasesPage).search_for_duns
end
