class ControlPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:add_document) {|b| b.div(class: "add-req-doc".split).parent.a(href: "javascript:void(0)")}
  element(:add_document_button) {|b| b.div(class: "add-req-doc-button".split).parent.a(href: "javascript:void(0)")}
  element(:associate_document_link) {|b| b.div(class: "options-box".split).parent.button(:id => "doc-lib-button",:text => "Choose from document library")}
  element(:upload_document) {|b| b.div(class: "options-box".split).parent.button(id: "doc-upload-button")}
  element(:upload_document_link) {|b| b.div(class: "dz-default dz-message".split).parent.a(id: "dz-select-eight_a_us_citizenship")}
  element(:upload_button) {|b| b.button(id: "attach", :text => "Upload")}
  element(:associate_button) {|b| b.button(id: "document_library_associate", :text => "Associate")}
  element(:save_continue_button) {|b| b.input(id: "section_submit_button", :value => "Continue")}
  element(:signature_continue_button) {|b| b.input(id: "accept-button", :value => "Continue")}

  def screen_shot()
    opts = { :page_height_limit => 5000 }
    path = "features/screenshots/Control_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
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

  def refactor_this_second(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text')
    item.each do |textloop|
      if textloop.text == "#{key}"
        item1 = textloop.element(:xpath => './following::div/following::div')
        button_associate = item1.parent.div(class: 'add-req-doc').a(href: "javascript:void(0)").i(class: "fa fa-plus-circle")
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().inspect
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 30).click
        item1.parent.div(class: 'right-align').div.button(id: "document_library_associate").click
      end
    end
  end

  def refactor_this_index(value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    button_associate = browser.h3(:index => "#{value}".to_i).parent.div(class: 'add-req-doc').a(href: "javascript:void(0)").i(class: "fa fa-plus-circle")
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:index => "#{value}".to_i).parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    sleep 0.5
    browser.h3(:index => "#{value}".to_i).parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:index => "#{value}".to_i).parent.div(class: 'right-align').div.button(id: "document_library_associate").click
  end

  def search_result_present(key, value)
    browser.a(:id => "#{key}", :class => "completed").text.include? value
  end

  def assert_complete_section(key, value)
    browser.h3(:class => "usa-alert-heading").text.include? key
    browser.p(:class => "usa-alert-text").text.include? value
  end

  def continue()
    browser.h2(:text => "Taxes").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
    # browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
  end

  def continue_submit(value)
    browser.h2(:text => "#{value}").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
#    browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
  end

  def control_submit()
    $review_button = browser.input(:class => "review", :value => "Submit")
    $review_button.wait_until_present(timeout: 10).click
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'vendor_control.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def complete_control_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key
        when "agreements that might impact ownership or control_as_yes"
          radio_option_index_yes(value)

        when "agreements that might impact ownership or control_as_no"
          radio_option_index_no_last(value)

        when "support or bonding support to the applicant firm_as_yes"
          radio_option_yes(value)

        when "support or bonding support to the applicant firm_as_no"
          radio_option_no_last(value)

        when "permits to the applicant firm_as_yes"
          radio_option_yes(value)

        when "permits to the applicant firm_as_no"
          radio_option_no_last(value)

        when "disadvantaged status the highest compensated in the applicant firm_as_yes"
          radio_option_yes(value)

        when "disadvantaged status the highest compensated in the applicant firm_as_no"
          radio_option_no_last(value)

        when "Please upload all business bank account signature cards."
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

        when "complete_all_firm_control"
          browser.h3(:index => 0).parent.label(class: 'no last').wait_until_present(timeout: 10).click
          browser.h3(:index => 3).parent.label(class: 'no last').wait_until_present(timeout: 10).click
          browser.h3(:index => 6).parent.label(class: 'no last').wait_until_present(timeout: 10).click
          browser.h3(:index => 9).parent.label(class: 'yes').wait_until_present(timeout: 10).click
          refactor_this("Please upload all business bank account signature cards.")
          browser.h3(:index => 13).parent.label(class: 'no last').wait_until_present(timeout: 10).click
          browser.h3(:index => 16).parent.label(class: 'yes').wait_until_present(timeout: 10).click

        when "share any resources with any other firms_as_yes"
          radio_option_yes(value)

        when "share any resources with any other firms_as_no"
          radio_option_no_last(value)

        when "lease or use office space or other facilities from any other firm_as_yes"
          radio_option_yes(value)

        when "lease or use office space or other facilities from any other firm_as_no"
          radio_option_no_last(value)

        when "familial relationship with the owner of the leased facility_as_yes"
          radio_option_yes(value)

        when "familial relationship with the owner of the leased facility_as_no"
          radio_option_no_last(value)

        when "Submit"
          continue_submit(value)

        when "Save and Continue"
          # screen_shot()
          save_and_submit()

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
          control_review()

        when "Submit Control"
          control_submit()
          #      else
          #        puts "Missing element locator for  :  #{key}"
        end
      end
    end
  end
end