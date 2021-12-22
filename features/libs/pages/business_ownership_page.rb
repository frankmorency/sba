class BusinessOwnershipPage < GenericBasePage
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
    path = "features/screenshots/BusinessOwnership_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def dropdown_selection(key, value)
    #	browser.h3(:text => "#{key}").parent.select_list.selected_options.map(&:text)
    item = browser.h3(:text => "#{key}")
    item1 = item.element(:xpath => './following::div')
    item1.parent.select_list().option(:text, "#{value}").select
  end

  def enter_text(key, value)
    browser.div(:class => "comment".split, :text => "#{key}").parent.textarea().send_keys value
  end

  def click_associate_button()
    associate_button.wait_until_present(timeout: 10).click
  end

  def refactor_this(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{key}"
        item1 = textloop.element(:xpath => './following::div/div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
        item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").click
      end
    end
  end

  def refactor_this_second(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{key}"
        item1 = textloop.element(:xpath => './following::div/following::div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 10).click
        item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").wait_until_present(timeout: 10).click
      end
    end
  end

  def refactor_text_contains(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{key}"
        item1 = textloop.element(:xpath => './following::div/following::div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 10).click
        item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").wait_until_present(timeout: 10).click
      end
    end
  end

  def refactor_this_index(value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 2.5
        browser.send_keys(:page_down)
        # item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 10).click
        #  item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").wait_until_present(timeout: 10).click
        new_item = tem1.parent.table(class: 'display-table'.split)
        row = new_item.trs.find {|tr| tr[0].text.include? "qa_automation.pdf"}
        row.td(:index => 0).a.click

        item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").wait_until_present(timeout: 10).click
      end
    end
  end

  def refactor_this_true_index(value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    button_associate = browser.h3(:index => "#{value}".to_i).parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:index => "#{value}".to_i).parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    browser.h3(:index => "#{value}".to_i).parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:index => "#{value}".to_i).parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").click
  end

  def enter_ownership_values(value)
    input_string = value.split(",")
    input_string.size.times do |i|
    end
    browser.divs(:class => 'block'.split).each do |textloop|
      textloop.divs(:class => 'usa-width-two-thirds'.split).each do |item|
        case item.text

        when "Individuals  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[1..1])

        when "Other firms  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[3..3])

        when "American Indian Tribe (AIT)  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[5..5])

        when "Alaska Native Corporation (ANC)  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[7..7])

        when "Community Development Corporation (CDC)  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[9..9])

        when "Native Hawaiian Organization (NHO)  "
          item.element(:xpath => './following::div/input').wait_until_present(timeout: 10).send_keys(input_string[11..11])

        else
          # puts "Missing element locator for  :  #{value}"
        end
      end
    end
  end

  def business_ownership_submit()
    $review_button = browser.input(:class => "review".split, :value => "Submit")
    $review_button.wait_until_present(timeout: 10).click
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'business_ownership_details.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def complete_business_ownership_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key

        when "Who owns the applicant firm"
          enter_ownership_values(value)

        when "51% or more unconditionally owned by another entity_as_yes"
          radio_option_yes(value)

        when "51% or more unconditionally owned by another entity_as_yes_document"
          refactor_this_second(value)

        when "Please explain why you made this choice."
          browser.div(:class => "comment required".split, :text => "#{key}").parent.textarea().send_keys value

        when "51% or more unconditionally owned by another entity_as_no"
          radio_option_no_last(value)

        when "How did the Principal Owner(s) acquire the applicant firm?"
          dropdown_selection(key, value)

        when "legal structure, or name changed in the past two years_as_yes"
          radio_option_yes(value)

        when "legal structure, or name changed in the past two years_as_yes_as_document"
          refactor_this_second(value)

        when "legal structure, or name changed in the past two years_as_no"
          radio_option_no_last(value)

        when "unconditional ownership of the disadvantaged individuals_as_yes"
          radio_option_yes(value)

        when "unconditional ownership of the disadvantaged individuals_as_yes_as_document"
          refactor_this_second(value)

        when "unconditional ownership of the disadvantaged individuals_as_no"
          radio_option_no_last(value)

        when "currently have ownership interest in any other firm_as_yes"
          radio_option_yes(value)

        when "currently have ownership interest in any other firm_as_yes_as_document"
          refactor_this_second(value)

        when "currently have ownership interest in any other firm_as_no"
          radio_option_no(value)

        when "more than 10% ownership interest in the applicant firm_as_yes"
          radio_option_yes(value)

        when "more than 10% ownership interest in the applicant firm_as_yes_as_document"
          refactor_this_second(value)

        when "more than 10% ownership interest in the applicant firm_as_no"
          radio_option_no(value)

        when "Please upload all relevant documents from the following list for Articles of Incorporation"
          refactor_text_contains(value)

        when "Please upload all relevant documents from the following list for Stock certificates"
          refactor_text_contains(value)

        when "Please upload all relevant documents for current Certificate of Good Standing"
          refactor_this(value)

        when "LLCs Articles of Organization documents"
          refactor_this_true_index(value)

        when "LLCs current Certificate of Good Standing"
          refactor_this(value)

        when "Current Partnership Agreement"
          refactor_this(value)

        when "Doing Business As DBA Name_as_yes"
          radio_option_yes(value)

        when "Doing Business As DBA Name_as_no"
          radio_option_no_last(value)

        when "Doing Business As DBA Name_as_yes_document"
          refactor_this_second(value)

        when "Please explain why you made this choice."
          enter_text(key, value)

        when "Save and Continue"
          #  screen_shot()
          save_continue()

        when "Complete Status"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          value1 = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          value2 = input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          sleep 1
          search_result_present(value1,value2)

        when "Submit"
          continue_submit(value)

        when "Success"
          assert_complete_section(key, value)

        when "Review left navigation"
          business_ownership_review(value)

        when "Submit Business Ownership"
          business_ownership_submit()

        else
          #  implement logic later "ERROR<<<FAILED>>>Missing element locator for  :  #{key}"
        end
      end
    end
  end
end