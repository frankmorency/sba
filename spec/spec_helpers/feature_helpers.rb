module FeatureHelpers
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.evaluate_script("jQuery.active").zero?
    end
  end

  def visit(link)
    super link
    screenshot_and_save_page if @screenshot
  end

  def l(str)
    I18n.l(str)
  end

  def within_table(id)
    within(:xpath, "//table[@id='#{id}']/tbody") do
      yield
    end
  end

  # def within_column(column)
  #   within(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th[normalize-space()='#{column}']/preceding-sibling::th)+1]") do
  #     yield
  #   end
  # end
  #
  # def within_row(name)
  #   within(:xpath, "//tr[td='#{name}']") { yield }
  # end
  #
  def create_mat_view_for_org(duns, business_name = 'Entity 372 Legal Business Name')
    new_row = "#{duns}||975BG||A|Z2|20120822|20141107|20140122|20131107|#{business_name}||||Entity 372 Address Line 1||NAKAGAMI-GUN||9040103||JPN||20120928|0914|93|93||2J||JPN|0003|2X~A5~VW||622110|0001|622110Y|0000||N||Entity 372 Mailing Address Line 1||CHATAN|904||JPN||SAM|A|MERICA|Entity 372 POC TITLE|Entity 372 Address Line 1||CHATAN|9040103||JPN|NAKAGAMI-GUN|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||||||||||||||||||SAM|A|MERICA|Entity 372 POC Title|Entity 372 Address Line 1||CHATAN|9040103||JPN|NAKAGAMI-GUN|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||SAM|A|MERICA|Entity 372 POC Title|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||||||||N|||||||||||||||1|123456789|1|42000|Entity 372 Financial Institute Name|1234567|123456789|S||20120828|N||5555-55555555555|||Entity 372 Remittance Name|Entity 372 Address Line 1||CHATAN||9040103||JPN|SAM|A|MERICA|Entity 372 POC Title|||5555-55555555555||something@sam.gov|||||||||||||||||A12345678|0000||N||0000||0000|||0000|||||123456789|123456789|||||||||||||||||||||||||||||||||||||||||!end
".split('|')
    new_row.pop
    new_row.map! { |element| "'#{element}'" }
    insert_values = new_row.join(", ")
    ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations VALUES (#{insert_values})")
    MvwSamOrganization.refresh
  end

  def seed_claim_a_business
    ActiveRecord::Base.connection.execute("TRUNCATE sam_organizations;")
    new_row = "595621168||975BG||A|Z2|20120822|20141107|20140122|20131107|Entity 372 Legal Business Name||||Entity 372 Address Line 1||NAKAGAMI-GUN||9040103||JPN||20120928|0914|93|93||2J||JPN|0003|2X~A5~VW||622110|0001|622110Y|0000||N||Entity 372 Mailing Address Line 1||CHATAN|904||JPN||SAM|A|MERICA|Entity 372 POC TITLE|Entity 372 Address Line 1||CHATAN|9040103||JPN|NAKAGAMI-GUN|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||||||||||||||||||SAM|A|MERICA|Entity 372 POC Title|Entity 372 Address Line 1||CHATAN|9040103||JPN|NAKAGAMI-GUN|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||SAM|A|MERICA|Entity 372 POC Title|||5555-55555555555||something@sam.gov|||||||||||||||||||||||||||||||||||||||N|||||||||||||||1|123456789|1|42000|Entity 372 Financial Institute Name|1234567|123456789|S||20120828|N||5555-55555555555|||Entity 372 Remittance Name|Entity 372 Address Line 1||CHATAN||9040103||JPN|SAM|A|MERICA|Entity 372 POC Title|||5555-55555555555||something@sam.gov|||||||||||||||||A12345678|0000||N||0000||0000|||0000|||||123456789|123456789|||||||||||||||||||||||||||||||||||||||||!end
".split('|')
    new_row.pop
    new_row.map! { |element| "'#{element}'" }
    insert_values = new_row.join(", ")
    ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations VALUES (#{insert_values})")
    MvwSamOrganization.refresh
    user = User.new(first_name: "Claim", last_name: "Jumper", email: "claim_jumper@mailinator.com", password: 'Not@allthepassword1', password_confirmation: 'Not@allthepassword1', confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YClaimJumper", confirmed_at: Time.now)
    user.skip_confirmation!
    user.save!
  end

  def seed_a_vendor

  end

  def click_button(locator = nil, options={})
    sleep_duration = options.delete(:sleep)
    super locator, options
    sleep(sleep_duration) if sleep_duration
    screenshot_and_save_page if @screenshot
  end

  def click_link(locator = nil, options={})
    sleep_duration = options.delete(:sleep)
    super locator, options
    sleep(sleep_duration) if sleep_duration
    screenshot_and_save_page if @screenshot
  end

  def should_open_url_in_new_tab(url)
    within_window windows.last do
      expect(current_url).to eq(url)
    end
  end

  def should_have_page_content(*arg)
    within('#main-content') do
      should_have_content *arg
    end
  end


  def should_not_have_page_content(*arg)
    within('#main-content') do
      should_not_have_content *arg
    end
  end

  def should_have_content(*arg)
    arg.each do |a|
      expect(page).to have_content(a)
    end
  end

  def should_not_have_content(*arg)
    arg.each do |a|
      expect(page).not_to have_content(a)
    end
  end

  def should_have_quantity(css, n)
    count = page.evaluate_script "$('#{css}').length;"
    expect(count).to eq(n)
  end

  def manually_create_a_pending_application(certificate_type)
    visit "/certificate_types/#{certificate_type.name}/application_types/initial/sba_applications/new"
    expect(page).to have_content("The Questionnaire Program Certification")
    click_button 'Accept'

    expect(page).to have_content("Eligibility")
    page.find('#answers_must_answer_yes label.yes').trigger(:click)
    page.find('#answers_must_answer_no label.no').trigger(:click)
    click_button 'Save and continue'

    expect(page).to have_content("How Big")
    page.find('#answers_is_it_big label.yes').trigger(:click)
    click_button 'Save and continue'

    expect(page).to have_content("The Size (again)")
    page.find('#answers_do_you_mean_it label.yes').trigger(:click)
    click_button 'Save and continue'

    expect(page).to have_content("Other Questions")
    page.find('#answers_do_you_like_it label.yes').trigger(:click)
    click_button 'Save and continue'

    finish_application
  end

  def finish_application
    expect(page).to have_content("Review")
    sleep 1
    page.accept_confirm do
      click_button 'Submit'
    end

    expect(page).to have_content("Signature")

    page.find("input#legal_0", visible: false).trigger(:click)
    page.find("input#legal_1", visible: false).trigger(:click)
    page.find("input#legal_2", visible: false).trigger(:click)
    page.find("input#legal_3", visible: false).trigger(:click)
    page.find("input#legal_4", visible: false).trigger(:click)
    page.find("input#legal_5", visible: false).trigger(:click)

    click_button 'Accept'

    expect(page).to have_content('Your application has been submitted')
  end

  def test_fill_in_case_search_text_field_with_pill(id, text, pill_tag, query_tag)
      page.fill_in(id, with: text)
      within ".usa-search-big" do
        page.find("button").click
      end
      should_have_content pill_tag
      expect(page).to have_current_path(/#{query_tag}/)
      page.fill_in(id, with: "")
      within ".usa-search-big" do
        page.find("button").click
      end
      should_not_have_content pill_tag
  end

  def test_fill_in_case_search_text_field(id, text, pill_tag, query_tag)
      page.fill_in(id, with: text)
      within ".usa-search-big" do
        page.find("button").click
      end
      should_not_have_content pill_tag
      expect(page).to have_current_path(/#{query_tag}/)
      page.fill_in(id, with: "")
      within ".usa-search-big" do
        page.find("button").click
      end
      should_not_have_content pill_tag
  end

  def fill_in_search_annual_review(type)
    page.find('label[for='+type+'_ar_screening]').click
    page.find('label[for='+type+'_ar_returned_with_deficiency_letter]').click
    page.find('label[for='+type+'_ar_processing]').click
    page.find('label[for='+type+'_ar_retained]').click
    page.find('label[for='+type+'_ar_early_graduation_recommended]').click
    page.find('label[for='+type+'_ar_termination_recommended]').click
    page.find('label[for='+type+'_ar_voluntary_withdrawal_recommended]').click
  end

  def fill_in_search_initial_application(type)
    page.find('label[for='+type+'_ia_screening]').click
    page.find('label[for='+type+'_ia_returned_with_15_day_letter]').click
    page.find('label[for='+type+'_ia_closed]').click
    page.find('label[for='+type+'_ia_processing]').click
    page.find('label[for='+type+'_ia_sba_declined]').click
    page.find('label[for='+type+'_ia_pending_reconsideration]').click
    page.find('label[for='+type+'_ia_pending_reconsideration_or_appeal]').click
    page.find('label[for='+type+'_ia_reconsideration]').click
    page.find('label[for='+type+'_ia_appeal]').click
    page.find('label[for='+type+'_ia_sba_approved]').click
  end

end