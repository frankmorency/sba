class CharacterInformationPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload


  element(:add_document) {|b| b.div(class: "add-req-doc".split).parent.a(href: "javascript:void(0)")}
  element(:add_document_button) {|b| b.div(class: "add-req-doc-button".split).parent.a(href: "javascript:void(0)")}
  element(:associate_document_link) {|b| b.div(class: "doc-options".split).parent.button(:text => "Choose from document library")}
  element(:upload_document) {|b| b.div(class: "doc-options".split).parent.button(id: "doc-upload-button")}
  element(:upload_document_link) {|b| b.div(class: "dz-default dz-message".split).parent.a(id: "dz-select-eight_a_pos_taxes")}
  element(:upload_button) {|b| b.button(id: "attach", :text => "Upload")}
  element(:associate_button) {|b| b.button(id: "document_library_associate", :text => "Associate")}
  element(:save_continue_button) {|b| b.input(id: "section_submit_button", :value => "Save and continue")}

  def screen_shot()
    opts = { :page_height_limit => 5000 }
    path = "features/screenshots/Character_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def refactor_this(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text')
    item.each do |textloop|
      if textloop.text == "#{key}"
        item1 = textloop.element(:xpath => './following::div/div')
        button_associate = item1.parent.div(class: 'add-req-doc').a(href: "javascript:void(0)").i(class: "fa fa-plus-circle")
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().click
        item1.parent.div(class: 'right-align').div.button(id: "document_library_associate").click
      end
    end
  end

  def continue()
    browser.input(id: "section_submit_button").click
  end

  def character_review(value)
    element = browser.execute_script("return document.body")
    browser.execute_script("return arguments[0].tagName", element) #=> "BODY"
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until {browser.a(:id => "review")}
    browser.a(:id => "review", :text => "#{value}").click
  end

  def character_submit()
    $review_button = browser.input(:class => "review", :value => "Submit")
    $review_button.click
  end

  def assert_complete_section(key, value)
    sleep 1
    browser.h3(:class => "usa-alert-heading").text.include? key
    browser.p(:class => "usa-alert-text").text.include? value
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'character_details.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def complete_character_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key
        when "ever_been_debarred_or_suspended_by_any_Federal_entity_as_yes"
          radio_option_yes(value)

        when "ever_been_debarred_or_suspended_by_any_Federal_entity_as_no"
          radio_option_no_last(value)

        when "Is_the_applicant_firm_a_defendant_in_any_pending_lawsuit_as_yes"
          radio_option_yes(value)

        when "Is_the_applicant_firm_a_defendant_in_any_pending_lawsuit_as_no"
          radio_option_no_last(value)

        when "filed_for_bankruptcy_or_insolvency_within_the_past_7_years_as_yes"
          radio_option_yes(value)

        when "filed_for_bankruptcy_or_insolvency_within_the_past_7_years_as_no"
          radio_option_no_last(value)

        when "outstanding_delinquent_federal_state_or_local_financial_obligations_or_liens_filed_as_yes"
          radio_option_yes(value)

        when "outstanding_delinquent_federal_state_or_local_financial_obligations_or_liens_filed_as_no"
          radio_option_no_last(value)

        when "Continue"
          #  screen_shot()
          continue()

        when "Complete Status"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          value1 = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          value2 = input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          search_result_present(value1,value2)

        when "Success"
          assert_complete_section(key, value)

        when "Review left navigation"
          character_review(value)

        when "Submit Character"
          character_submit()

          #      else
          #        puts "Missing element locator for  :  #{key}"
        end
      end
    end
  end
end
