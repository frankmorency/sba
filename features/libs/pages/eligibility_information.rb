class EligibilityInformation < GenericBasePage
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
    path = "features/screenshots/Eligibility_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def wait_until(value)
    #	puts browser.execute_script("return window.location.pathname")
    # pass elements between Ruby and JavaScript
    element = browser.execute_script("return document.body")
    browser.execute_script("return arguments[0].tagName", element) #=> "BODY"
    # # wait for a specific element to show up
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until {value}
  end

  def click_associate_button()
    associate_button.wait_until_present(timeout: 10).click
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

  def refactor_this(key, value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    button_associate = browser.h3(:text => "#{key}").parent.div(class: 'add-req-doc').a(href: "javascript:void(0)").i(class: "fa fa-plus-circle")
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:text => "#{key}").parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    browser.h3(:text => "#{key}").parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:text => "#{key}").parent.div(class: 'right-align').div.button(id: "document_library_associate").click
    continue_submit("#{value}")
  end



  def upload_file_original(key, _file)
    add_document.wait_until_present(timeout: 10).click
    sleep 0.5
    upload_document.wait_until_present(timeout: 10).click
    sleep 0.5
    upload_document_link.wait_until_present(timeout: 10).click
    file_location = data_pdf("#{_file}")
    sleep 0.5
    #   puts "upload is in progress#"
    @browser.file_field().set file_location
    sleep 0.5
    #   puts "upload is in progress###"
    @browser.table(:id => "file_list_append").parent.input(id: 'comment').wait_until_present(20).send_keys "#{_file} : file uploaded"
    sleep 0.5
    upload_button.wait_until_present(timeout: 10).click
    sleep 0.5
    #  puts "upload is completed###"
    table = @browser.table(:id => "currently_attached")
    starting_row_index = browser.table.rows.to_a.index {|row| row.td(:id => "document_library_file_name", :text => "#{_file}").present?}
  end

  def associate_document_original(key, _file)
## need to refactor this method

    button_associate = browser.h3(:text => "#{key}").parent.div(class: 'add-req-doc').a(href: "javascript:void(0)").i(class: "fa fa-plus-circle")
    button_associate.wait_until_present(timeout: 10).click

    buttons = browser.h3(:text => "#{key}").parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    table = browser.table(:class => "display-table")
    sleep 0.5
    starting_row_indexa = table.rows.to_a.index {|row| row.td(:id => "document_library_file_name").present?}
    #  puts table.rows.length
    (starting_row_indexa).upto(table.rows.length - 1) {|x|
      #      puts browser.table[x][0].text
      if browser.table[x][0].text == "#{_file}"
        browser.table[x][0].click
        associate_button.wait_until_present(5).click
#          puts "association is for this successful"
        sleep 0.5
        browser.h2(:text => "Revenue").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
        break
      end
    }

  end

  def associate_document(key, _file)
    associate_document_link.wait_until_present(30).click
    sleep 0.5
    table = browser.table(:class => "display-table").wait_until_present(timeout: 10)
    sleep 0.5
    starting_row_index = table.rows.to_a.index {|row| row.td(:id => "document_library_file_name").present?}
    # puts table.rows.length
    begin
      (starting_row_index).upto(table.rows.length - 1) {|x|
        #      puts browser.table[x][0].text
        if browser.table[x][0].text == "#{_file}"
          browser.table[x][0].click
          associate_button.wait_until_present(5).click
          puts "association is successful"
          sleep 0.5
          continue()
          break
        end
      }
    rescue
    else
      sleep 0.5
      upload_file(key, _file)
      #     continue()
      sleep 0.5
    end
  end

  def document(key, _file)
    browser.a(:id => "eight_a_pos_taxes").wait_until_present(timeout: 10).click
    add_document.wait_until_present(timeout: 10).click
    begin
      associate_document(key, _file)
    end
  end

  def assert_not_applicable(key, value)
    #puts browser.a(:class => "#{key}").text
    browser.a(:class => "#{key}".split).text.include? value
  end

  def assert_complete_section(key, value)
    browser.h3(:class => "usa-alert-heading".split).text.include? key
    browser.p(:class => "usa-alert-text".split).text.include? value
  end

  def assert_new_section(value)
    browser.link(:text => "#{value}").text.include? value
  end

  def eligibility_review()
#   puts browser.execute_script("return window.location.pathname")
#   pass elements between Ruby and JavaScript
    element = browser.execute_script("return document.body")
    browser.execute_script("return arguments[0].tagName", element) #=> "BODY"
#   wait for a specific element to show up
    wait = Selenium::WebDriver::Wait.new(timeout: 5) # seconds
    wait.until {browser.a(:id => "review")}
    browser.a(:id => "review", :class => "usa-current".split).click
  end

  def refactor_this(key)
    ## refactor this
    #    browser.send_keys(:page_down)
    sleep 0.5
    button_associate = browser.h3(:text => "#{key}").parent.a(:text => "Add documents").i(class: 'fa fa-plus-circle')
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:text => "#{key}").parent.div(class: 'options-box').div(class: "doc-options").button(class: "usa-button-outline usa-button-active")
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
#    browser.send_keys(:page_down)
    browser.h3(:text => "#{key}").parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:text => "#{key}").parent.div(class: 'right-align').div.button(id: "document_library_associate").click
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
    browser.h3(:index => "#{value}".to_i).parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:index => "#{value}".to_i).parent.div(class: 'right-align').div.button(id: "document_library_associate").click
  end

  def eligibility_submit()
    $review_button = browser.input(:class => "review".split, :value => "Submit")
    $review_button.click
  end


  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'vendor_eligibility.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def assert_new_section_iterate(value)
    iterate_array_type = data_yml_hash["Expected sections that are added"]
    iterate_array_values = iterate_array_type.split(",")
    #puts iterate_array_values
    iterate_given_values = value.split(",")
    #puts iterate_given_values
    for i in 0..4
      for j in 0..4
        if iterate_array_values[i] == iterate_given_values[j]
          browser.link(:text => "#{iterate_array_values[i]}").text.include? iterate_given_values[j]
          # puts " #{iterate_given_values[j]} :>><<: #{iterate_array_values[i]}"
        end
      end
    end
  end

  def complete_eligibility_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key
        when "answers_for_profit_as_yes"
          radio_option_yes(value)

        when "answers_for_profit_as_no"
          radio_option_no_last(value)

        when "answers_is_broker_as_yes"
          radio_option_yes(value)

        when "answers_is_broker_as_no"
          radio_option_no_last(value)

        when "answers_generate_revenue_as_yes"
          radio_option_yes(value)

        when "answers_generate_revenue_as_no"
          radio_option_no(value)

        when "answers_generate_revenue_as_not_applicable"
          radio_option_no_last(value)

        when "answers_disadvantaged_citizens_as_yes"
          radio_option_yes(value)

        when "answers_disadvantaged_citizens_as_no"
          radio_option_no_last(value)

        when "answers_have_dba_as_yes"
          radio_option_yes(value)

        when "answers_have_dba_as_no"
          radio_option_no(value)

        when "answers_have_dba_as_not_applicable"
          radio_option_no_last(value)

        when "Please explain why you made this choice."
          enter_div_text(key, value)

        when "applicant firm ever a certified 8a_as_yes"
          radio_option_yes(value)

        when "applicant firm ever a certified 8a_as_no"
          radio_option_no_last(value)

        when "ever submitted an application to the 8a_as_yes"
          radio_option_yes(value)

        when "ever submitted an application to the 8a_as_no"
          radio_option_no_last(value)

        when "ever submitted an application to the 8a_as_yes_text_box"
          enter_text(value)

        when "50 percent more of applicant firms assets_as_yes"
          radio_option_yes(value)

        when "50 percent more of applicant firms assets_as_no"
          radio_option_no_last(value)

        when "hire an outside consultant to assist with its 8a application_as_yes"
          radio_option_yes(value)

        when "hire an outside consultant to assist with its 8a application_as_no"
          radio_option_no_last(value)

        when "firm considered NAICS code_as_yes"
          radio_option_yes(value)

        when "firm considered NAICS code_as_no"
          radio_option_no_last(value)

        when "received a formal SBA size determination_as_yes"
          radio_option_yes(value)

        when "received a formal SBA size determination_as_no"
          radio_option_no_last(value)

        when "Please upload the size determination or redetermination letter(s) issued by SBA."
          refactor_this_index(value)

        when "Which SBA area office sent the most recent letter?"
          dropdown_selection(key, value)

        when "What is the determination date stated in the most recent letter?"
          enter_calender_text(key, value)

        when "Save and Continue"
          # screen_shot()
          save_and_submit()

        when "eight_a_basic_eligibility_size"
          search_result_present(key, value)

        when "eight_a_basic_eligibility_size_determination"
          search_result_present(key, value)

        when "notapplicable"
          assert_not_applicable(key, value)

        when "Complete Status"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          value1 = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          value2 = input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          search_result_present(value1,value2)

        when "Success"
          assert_complete_section(key, value)

        when "New Section Added"
          assert_new_section_iterate(value)

        when "Review left navigation"
          eligibility_review()

        when "Submit Eligibility"
          eligibility_submit()

          #      else
          #        puts "Missing element locator for  :  #{key}"
        end
      end
    end
  end
end
