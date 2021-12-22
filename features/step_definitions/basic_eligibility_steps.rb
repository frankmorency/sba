When("the vendor completes the {string}") do |string|
  sleep 5
  $var_out = on(LoginPage).company_info()
  unique_element = @browser.div(:class => "usa-width-one-whole".split).parent.table(:id => "certifications")
  if unique_element.present?
    row = unique_element.trs.find {|tr| tr[0].text == "8(a) Initial Application" && tr[1].text == "Initial" && tr[2].text == "Draft"}
    row1 = unique_element.trs.find {|tr| tr[0].text == "8(a) Initial Application" && tr[1].text == "Initial" && tr[2].text == "Pending"}
    row2 = unique_element.trs.find {|tr| tr[0].text == "8(a) Initial Application" && tr[1].text == "Certificate" && tr[2].text == "Active"}
    annual_review = unique_element.trs.find {|tr| tr[0].text == "8(a) Annual Review" && tr[1].text == "Annual Review"}
    new_application = @browser.div(:class => "usa-width-one-whole".split).parent.p(:text => /Get started now on your/)
  end

  if annual_review.present? && row2.present?
    case string
    when "method to create annual review"
      on(WelcomePage).eight_a_annual_review.wait_until_present(timeout: 10).click

    end

  elsif row2.present? && !annual_review.present?
    case string

    when "method to create annual review"
      on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    end

  elsif !unique_element.present?

    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    on(WelcomePage).accept_button_8a.wait_until_present(timeout: 10).click
    sleep 5

    case string

    when "Eligibility Information"
      # delete logic need to be applied, application is bit slow , added more sleep 20
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "Eligibility Information with size"
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize as yes")
      on(EligibilityInformation).complete_eligibility_section(string, "Size Determination")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "application deletion"
      on(LoginPage).account()
      on(LoginPage).logout()

    when "8a initial application with autofill"
      on(WelcomePage).new_page_click()
      on(WelcomePage).initial_fill()
      sleep 20
      on(WelcomePage).eight_a.wait_until_present(timeout: 10).click

    end

  elsif new_application.present? && (!row1.present? && !row.present?) && !row2.present?
    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    on(WelcomePage).accept_button_8a.wait_until_present(timeout: 10).click
    sleep 5

    case string

    when "Eligibility Information"
      # delete logic need to be applied, application is bit slow , added more sleep 20
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "Eligibility Information with size"
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize as yes")
      on(EligibilityInformation).complete_eligibility_section(string, "Size Determination")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "application deletion"
      on(LoginPage).account()
      on(LoginPage).logout()

    when "8a initial application with autofill"
      on(WelcomePage).new_page_click()
      on(WelcomePage).initial_fill()
      sleep 20
      on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    end

  elsif new_application.present? || (row.present? && !row1.present? || !row2.present?)
    row.td(:index => 6).a.click
    @browser.alert.wait_until_present(timeout: 10).ok
    on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    on(WelcomePage).accept_button_8a.wait_until_present(timeout: 10).click
    sleep 5

    case string

    when "Eligibility Information"
      # delete logic need to be applied, application is bit slow , added more sleep 20
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "Eligibility Information with size"
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize as yes")
      on(EligibilityInformation).complete_eligibility_section(string, "Size Determination")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "application deletion"
      on(LoginPage).account()
      on(LoginPage).logout()

    when "8a initial application with autofill"
      on(WelcomePage).new_page_click()
      on(WelcomePage).initial_fill()
      sleep 20
      on(WelcomePage).eight_a.wait_until_present(timeout: 10).click
    end

  elsif unique_element.exists? == true
    table = unique_element.parent
    row = table.trs.find {|tr| tr[0].text == "#{date}" && tr[1].text == 'Initial'}
    on(WelcomePage).delete_initial_application("8(a) Initial Application", "Initial", "Draft")
    sleep 5
    on(WelcomePage).eight_a.wait_until_present(timeout: 30).click
    on(WelcomePage).accept_button_8a.wait_until_present(timeout: 30).click
    sleep 5
    case string

    when "Eligibility Information"
      # delete logic need to be applied, application is bit slow , added more sleep 20
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "Eligibility Information with size"
      on(EligibilityInformation).complete_eligibility_section(string, "General Assessment")
      on(EligibilityInformation).complete_eligibility_section(string, "Prior 8a Involvement")
      on(EligibilityInformation).complete_eligibility_section(string, "Outside Assistance")
      on(EligibilityInformation).complete_eligibility_section(string, "BusinessSize as yes")
      on(EligibilityInformation).complete_eligibility_section(string, "Size Determination")
      on(EligibilityInformation).complete_eligibility_section(string, "Review Submit")

    when "application deletion"
      on(LoginPage).account()
      on(LoginPage).logout()

    when "8a initial application with autofill"
      on(WelcomePage).new_page_click()
      on(WelcomePage).initial_fill()
      sleep 2
      on(WelcomePage).assert_complete_section("Notice", "Your app has been prepopulated - you can now go submit it")
      on(WelcomePage).eight_a.wait_until_present(timeout: 10).click

    end
  end
end

