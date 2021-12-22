class ContributorsPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:add_document) {|b| b.div(class: "add-req-doc".split).parent.a(href: "javascript:void(0)")}
  element(:add_document_button) {|b| b.div(class: "add-req-doc-button".split).parent.a(href: "javascript:void(0)")}
  element(:associate_document_link) {|b| b.div(class: "doc-options".split).parent.button(:text => "Choose from document library")}
  element(:upload_document) {|b| b.div(class: "doc-options".split).parent.button(id: "doc-upload-button")}
  element(:upload_document_link) {|b| b.div(class: "dz-default dz-message".split).parent.a(id: "dz-select-eight_a_us_citizenship")}
  element(:upload_button) {|b| b.button(id: "attach", :text => "Upload")}
  element(:associate_button) {|b| b.button(id: "document_library_associate", :text => "Associate")}
  element(:save_continue_button) {|b| b.input(id: "section_submit_button", :value => "Continue")}
  element(:signature_continue_button) {|b| b.input(id: "accept-button", :value => "Continue")}

  def screen_shot()
    opts = {:page_height_limit => 5000}
    path = "features/screenshots/Accept_Signature_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def click_associate_button()
    associate_button.wait_until_present(timeout: 30).click
  end

  def refactor_this(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    browser_status()
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
        browser_status()
      end
    end
  end

  def refactor_this_second(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    browser_status()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{key}"
        item1 = textloop.element(:xpath => './following::div/following::div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        browser_status()
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        browser_status()
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().inspect
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 30).click
        item1.parent.div(class: 'right-align').div.button(id: "document_library_associate").click
        browser_status()
      end
    end
  end

  def add_support_document(key)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    browser_status()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{key}"
        item1 = textloop.element(:xpath => './following::div/following-sibling::div')
        item1.flash
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.flash
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        browser_status()
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        sleep 0.5
        browser_status()
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().inspect
        item1.parent.table(class: 'display-table').tbody().tr.td(id: "document_library_file_name").ul().li().label().wait_until_present(timeout: 30).click
        item1.parent.div(class: 'right-align').div.button(id: "document_library_associate").click
        browser_status()
      end
    end
  end

  def refactor_this_index(value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
        button_associate.wait_until_present(timeout: 10).click
        sleep 0.5
        buttons = item1.parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
        buttons.wait_until_present(timeout: 10).click
        sleep 0.5
        browser.send_keys(:page_down)
        item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
        item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").click
      end
    end
  end

  def refactor_this_true_index(value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    button_associate = browser.h3(:index => "#{value}".to_i).parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:index => "#{value}".to_i).parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    sleep 0.5
    browser.h3(:index => "#{value}".to_i).parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
    browser.h3(:index => "#{value}".to_i).parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").click
  end


  def upload_file_original(key, _file)
    add_document.inspect
    add_document.wait_until_present(timeout: 30).click
    sleep 0.5
    upload_document.inspect
    upload_document.wait_until_present(timeout: 30).click
    sleep 0.5
    link = browser.div(class: "dz-default dz-message".split).parent.a(id: "#{key}")
    link.inspect
    link.wait_until_present(timeout: 30).click
    file_location = data_pdf("#{_file}")
    sleep 0.5
    #   puts "upload is in progress#"
    @browser.file_field().set file_location
    sleep 0.5
    #   puts "upload is in progress###"
    @browser.table(:id => "file_list_append").parent.input(id: 'comment').wait_until_present(timeout: 20).send_keys "#{_file} : file uploaded"
    sleep 0.5
    upload_button.wait_until_present(timeout: 30).click
    sleep 0.5
    #  puts "upload is completed###"
    table = @browser.table(:id => "currently_attached")
    starting_row_index = browser.table.rows.to_a.index {|row| row.td(:id => "document_library_file_name", :text => "#{_file}").present?}
  end

  def associate_document_original(key, _file)
## need to refactor this method

    button_associate = browser.h3(:text => "#{key}").parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
    button_associate.wait_until_present(timeout: 10).click

    buttons = browser.h3(:text => "#{key}").parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    table = browser.table(:class => "display-table".split)
    sleep 0.5
    starting_row_indexa = table.rows.to_a.index {|row| row.td(:id => "document_library_file_name").present?}
    # puts table.rows.length
    (starting_row_indexa).upto(table.rows.length - 1) {|x|
      #      puts browser.table[x][0].text
      if browser.table[x][0].text == "#{_file}"
        browser.table[x][0].click
        associate_button.wait_until_present(timeout: 10).click
#          puts "association is for this successful"
        sleep 0.5
        browser.h2(:text => "Revenue").parent.input(id: 'section_submit_button').wait_until_present(timeout: 20).click
        break
      end
    }
  end

  def associate_document_original_modified(value, key, _file)
    begin
      browser.send_keys(:page_down)
      sleep 0.5
      item = browser.divs(:class => 'sba-c-question__primary-text'.split)
      item.each do |textloop|
        if textloop.text.include? "#{value}"
          item1 = textloop.element(:xpath => './following::div')
          button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
          button_associate.wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)
          sleep 0.5
          link = button_associate.element(:xpath => './following::div')
          linked = link.parent.button(:id => "doc-lib-button")
          linked.inspect
          linked.wait_until_present(timeout: 10).click
          sleep 0.5
          table = browser.table(:class => "display-table".split)
          sleep 0.5
          table.inspect
          # puts table.rows.length
          if table.rows.length == 1 || table.rows.length == 0
            sleep 0.5
            up_linked = link.parent.button(:id => "doc-upload-button")
            up_linked.inspect
            up_linked.wait_until_present(timeout: 10).click
            upload_file(key, _file)
            sleep 0.5
          elsif table.rows.length > 2 || table.rows.length == 2
            browser.send_keys(:page_down)
            sleep 0.5
            item1.parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
            item1.parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").click
            sleep 0.5
            break

          end
        end
      end
    end
  end


  def associate_document_second(value, key, _file)
    begin
      browser.send_keys(:page_down)
      sleep 0.5
      item = browser.divs(:class => 'sba-c-question__primary-text'.split)
      item.each do |textloop|
        if textloop.text == "#{value}"
          item1 = textloop.element(:xpath => './following::div/following::div')
          button_associate = item1.parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
          button_associate.wait_until_present(timeout: 10).click
          sleep 0.5
          associate_document_link.wait_until_present(timeout: 30).click
          sleep 0.5
          table = browser.table(:class => "display-table".split).wait_until_present(timeout: 30)
          sleep 0.5
          starting_row_index = table.rows.to_a.index {|row| row.td(:id => "document_library_file_name").present?}
          if table.rows.length == 1
            sleep 0.5
            upload_file(key, _file)
            sleep 0.5
          elsif table.rows.length > 1
            (starting_row_index).upto(table.rows.length - 1) {|x|
              if browser.table[x][0].text == "#{_file}"
                browser.table[x][0].click
                associate_button.wait_until_present(timeout: 10).click
                sleep 0.5
                break
              end
            }
          else
            sleep 0.5
            upload_file(key, _file)
            sleep 0.5
          end
        end
      end
    end
  end

  def document(value, key, _file)
    begin
      associate_document_second(value, key, _file)
    end
  end

  def document_original(value, key, _file)
    begin
      associate_document_original_modified(value, key, _file)
    end
  end

  def status_initial_application (string1, string2)
    sleep 0.5
    unique_element = browser.section(:class => "dashboard-section".split).parent.table().tbody().tr().td(:text => "#{string1}")
    if parent_element = unique_element.parent
      col1 = parent_element.td(:index => 0).text
      col2 = parent_element.td(:index => 1).text
      if col1 == "#{string1}" and col2 == "#{string2}"
        col1.include? string1
        col2.include? string2
      end
    end
  end

  # def search_result_present(key, value)
  #   sleep 0.5
  #   browser.a(:id => "#{key}", :class => "completed".split).inspect
  #   if browser.a(:id => "#{key}", :class => "completed".split).visible? && browser.a(:id => "#{key}", :class => "completed".split).present?
  #     browser.a(:id => "#{key}", :class => "completed".split).text.include? value
  #   end
  # end

  def assert_complete_section(key, value)
    browser.h3(:class => "usa-alert-heading".split).text.include? key
    browser.p(:class => "usa-alert-text".split).text.include? value
  end

  def save_continue()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    browser_status()
    save_continue_button.inspect
    save_continue_button.wait_until_present(timeout: 10).click
    sleep 0.5
    browser_status()
    #browser.send_keys(:page_down)

  end

  def save_continue_life_insurance()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    browser_status()
    save_continue_button.inspect
    save_continue_button.wait_until_present(timeout: 10).click
    sleep 0.5
    browser_status()
    #browser.send_keys(:page_down)

  end

  def continue_submit(value)
    browser.h2(:text => "#{value}").parent.input(id: 'section_submit_button').wait_until_present(timeout: 30).click
    # browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
  end

  def contributor_submit()
    $review_button = browser.input(:class => "review".split, :value => "Submit")
    $review_button.wait_until_present(timeout: 30).click
  end

  def delete_contributor(value)
    browser.section(:class => "usa-grid-full".split).links.each do |link|
      if link.text == "#{value}"
        link(:text => "#{value}").click
        sleep 2
        browser.div(:class => "notice_wrapper".split).parent.h3(:class => "usa-alert-heading".split).text.include? "Notice"
        break
      end
    end
  end

  def signed_accept()
    signature_continue_button.inspect
    signature_continue_button.wait_until_present(timeout: 30).click
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'individual_contributor_details.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def complete_contributor_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key

        when "Browser Status"
          browser_status()

        when "Firm Owner and Individual Claiming Disadvantage (or 'Disadvantaged Individual')"
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click

        when "Annual Review Contributor"
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click

        when "Please add another 8(a) Applicant, if applicable."
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)

        when "Please add the spouse of any Disadvantaged Individual."
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)

        when "Please add all other individuals directly involved with the business."
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)

        when "Name"
          input_string = value.split(">")
          input_string.size.times do |i|
          end
          sleep 2
          c = browser.h4(:id => input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), :text => input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')).element(:xpath => './following::form/fieldset')
          c.inspect
          d = c.parent.input(:id => "contributor_full_name", :name => "contributor[full_name]")
          d.inspect
          sleep 2
          d.wait_until_present(timeout: 10).click
          d.wait_until_present(timeout: 10).send_keys input_string[2..2]

        when "Email"
          input_string = value.split(">")
          input_string.size.times do |i|
          end
          c = browser.h4(:id => input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), :text => input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')).element(:xpath => './following::form/fieldset')
          c.inspect
          d = c.parent.input(:id => "contributor_email", :name => "contributor[email]")
          d.inspect
          sleep 2
          d.wait_until_present(timeout: 10).click
          d.wait_until_present(timeout: 10).send_keys input_string[2..2]

        when "Send_Invitation"
          input_string = value.split(">")
          input_string.size.times do |i|
          end
          c = browser.h4(:id => input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), :text => input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')).element(:xpath => './following::form/fieldset/ul')
          c.inspect
          d = c.parent.input(:value => "Send invitation to collaborate", :name => "commit", :type => "submit")
          d.inspect
          sleep 2
          d.wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)
          browser.refresh


        when "delete_contributor"
          delete_contributor(value)

        when "8(a) Disadvantaged Individual"
          click_accept_button(value)
          browser_status()

        when "Gender"
          dropdown_selection(key, value)

        when "Marital Status"
          select_radio_values(key, value)

        when "Social Security Number"
          enter_input_text(key, value)

        when "Best contact phone number"
          enter_input_text(key, value)

        when "Provide your current home address"
          input_string = value.split(",")
          input_string.size.times do |i|
          end

          street_address = browser.h3(:text => "#{key}")
          item1 = street_address.element(:xpath => './following::div')
          str1 = item1.parent.fieldset.label(:text => "Street Address")
          str1.element(:xpath => './following-sibling::input').send_keys input_string[1..1]


          city = browser.h3(:text => "#{key}")
          item2 = city.element(:xpath => './following::div')
          str2 = item2.parent.fieldset.div().div().label(:text => "City")
          str2.element(:xpath => './following-sibling::input').send_keys input_string[3..3]


          state = browser.h3(:text => "#{key}")
          item3 = state.element(:xpath => './following::div')
          str3 = item3.parent.fieldset.div().div(:class => "usa-input-grid usa-input-grid-small".split)
          str3.click
          str3.select_list().option(:value => "VA").select


          zip = browser.h3(:text => "#{key}")
          item4 = zip.element(:xpath => './following::div')
          str4 = item4.parent.label(:text => "ZIP")
          str4.element(:xpath => './following-sibling::input').send_keys input_string[7..7]

        when "act as a director, management member, partner, or officer_as_yes"
          radio_option_yes(value)

        when "act as a director, management member, partner, or officer_as_no"
          radio_option_no_last(value)

        when "Dates of Residency"
          enter_calender_text(key, value)

        when "length of residency_as_yes"
          radio_option_yes_special(value)

        when "length of residency_as_no"
          radio_option_no_last(value)

        when "Date of Birth"
          enter_calender_text(key, value)

        when "Place of Birth"
          enter_input_text(key, value)

        when "Country of Birth"
          dropdown_label_selection(key, value)

        when "Are you a US Citizen_as_yes"
          radio_option_yes(value)

        when "Are you a US Citizen_as_no"
          radio_option_no_last(value)

        when "Are you a US Citizen_as_yes_document"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

        when "Upload your personal resume."
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

        when "What percentage of the Applicant Firm do you own?"
          enter_input_text(key, value)

        when "List all positions you hold in the Applicant Firm."
          enter_text(key, value)

        when "withdrawals from the Applicant Firm’s bank account_as_yes"
          radio_option_yes(value)

        when "withdrawals from the Applicant Firm’s bank account_as_no"
          radio_option_no_last(value)

        when "another job outside the Applicant Firm_as_yes"
          radio_option_yes(value)

        when "another job outside the Applicant Firm_as_no"
          radio_option_no_last(value)

        when "another job outside the Applicant Firm_as_yes_document"
          refactor_this_second(value)

        when "other firm that has a relationship with the Applicant Firm_as_yes"
          radio_option_yes(value)

        when "other firm that has a relationship with the Applicant Firm_as_no"
          radio_option_no_last(value)

        when "other firm that has a relationship with the Applicant Firm_as_yes_document"
          refactor_this_second(value)

        when "former employer of the Individual Claiming Disadvantage_as_yes"
          radio_option_yes(value)

        when "former employer of the Individual Claiming Disadvantage_as_no"
          radio_option_no(value)

        when "former majority owner (51% or more) of the Applicant Firm_as_yes"
          radio_option_yes(value)

        when "former majority owner (51% or more) of the Applicant Firm_as_yes_document"
          refactor_this_second(value)

        when "former majority owner (51% or more) of the Applicant Firm_as_no"
          radio_option_no(value)

        when "contractual relationship with the Applicant Firm_as_yes"
          radio_option_yes(value)

        when "contractual relationship with the Applicant Firm_as_no"
          radio_option_no_last(value)

        when "participated in the 8(a) Program_as_yes"
          radio_option_yes(value)

        when "participated in the 8(a) Program_as_no"
          radio_option_no_last(value)

        when "participated in the 8(a) Program_as_yes_document"
          refactor_this_second(value)

        when "used your one-time-only 8(a) eligibility_as_yes"
          radio_option_yes(value)

        when "used your one-time-only 8(a) eligibility_as_no"
          radio_option_no_last(value)

        when "your immediate family members ever owned a firm_as_yes"
          radio_option_yes(value)

        when "your immediate family members ever owned a firm_as_no"
          radio_option_no_last(value)

        when "your immediate family members ever owned a firm_as_yes_document"
          refactor_this_second(value)

        when "Federal Government employee holding a position of GS-13_as_yes"
          radio_option_yes(value)

        when "Federal Government employee holding a position of GS-13_as_no"
          radio_option_no_last(value)

        when "Federal Government employee holding a position of GS-13_as_yes_document"
          refactor_this_second(value)

        when "member of your household a Federal Government employee_as_yes"
          radio_option_yes(value)

        when "member of your household a Federal Government employee_as_no"
          radio_option_no_last(value)

        when "member of your household a Federal Government employee_as_yes_document"
          refactor_this_second(value)

        when "personal bankruptcy within the past 7 years_as_yes"
          radio_option_yes(value)

        when "personal bankruptcy within the past 7 years_as_no"
          radio_option_no_last(value)

        when "personal bankruptcy within the past 7 years_as_document"
          refactor_this_second(value)

        when "previously obtained an SBA loan_as_yes"
          radio_option_yes(value)

        when "previously obtained an SBA loan_as_no"
          radio_option_no_last(value)

        when "previously obtained an SBA loan_as_yes_document"
          refactor_this_second(value)

        when "party to a pending civil lawsuit_as_yes"
          radio_option_yes(value)

        when "party to a pending civil lawsuit_as_no"
          radio_option_no_last(value)

        when "party to a pending civil lawsuit_as_yes_document"
          refactor_this_second(value)

        when "delinquent in paying or filing any of the following_as_yes"
          radio_option_index_yes(value)

        when "delinquent in paying or filing any of the following_as_no"
          radio_option_index_no_last(value)

        when "delinquent in paying or filing any of the following_as_yes_document"
          browser_status()
          add_support_document(value)

        when "ever gone by any other names_as_yes"
          radio_option_yes(value)

        when "ever gone by any other names_as_no"
          radio_option_no_last(value)

        when "are you presently subject to an indictment_as_yes"
          radio_option_yes(value)

        when "are you presently subject to an indictment_as_no"
          radio_option_no_last(value)

        when "arrested in the past six months for any criminal offense_as_yes"
          radio_option_yes(value)

        when "arrested in the past six months for any criminal offense_as_no"
          radio_option_no_last(value)

        when "any criminal offense – other than a minor vehicle violation_as_yes"
          radio_option_index_yes(value)

        when "any criminal offense – other than a minor vehicle violation_as_no"
          radio_option_index_no_last(value)

        when "Upload a narrative for each arrest, conviction, or incident involving formal criminal charges brought against you"
          refactor_this(value)

        when "Upload copies of all relevant court dispositions or documents"
          refactor_this(value)

        when "Upload a completed Form FD-258 Fingerprint Card"
          refactor_this(value)

        when "Select one of the following “presumed disadvantaged groups” as the basis of your social disadvantage."
          dropdown_label_selection(key, value)

        when "provide documentation supporting your membership as Native American"
          refactor_this(value)

        when "transferred any assets to any immediate family member_as_yes"
          radio_option_yes(value)

        when "transferred any assets to any immediate family member_as_no"
          radio_option_no_last(value)

        when "Upload your personal Federal tax returns"
          refactor_this(value)

        when "Finanicial Data_Cash on Hand"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          d = DateTime.now
          d.strftime("%d/%m/%Y %H:%M")
          date = d.strftime("%m/%d/%Y")
          sleep 0.5
          enter_calender_div_classy(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), date)
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[3..3])
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[5..5])
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[6..6].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[7..7])
          sleep 0.5
          #    browser.send_keys(:page_down)

        when "Financial Data_Other Sources Of Income"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 0.5
          enter_div_id_h3(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1])
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[3..3])
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[5..5])
          browser.send_keys(:page_down)
          sleep 0.5
          enter_div_id_h3(input_string[6..6].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[7..7])
          sleep 0.5
          #   browser.send_keys(:page_down)


        when "Financial Data_Notes Receivable_as_yes"
          radio_option_yes(value)

        when "Financial Data_Notes Receivable_as_no"
          radio_option_no_last(value)

        when "Financial Data_Retirement Accounts_as_yes"
          radio_option_yes(value)

        when "Financial Data_Retirement Accounts_as_no"
          radio_option_no_last(value)

        when "Other_Retirement Accounts_as_yes"
          radio_option_yes(value)

        when "Other_Retirement Accounts_as_no"
          radio_option_no_last(value)

        when "Insurance policy that has a cash surrender value_as_yes"
          radio_option_yes(value)

        when "Insurance policy that has a cash surrender value_as_no"
          radio_option_no_last(value)

        when "loans against a life insurance policy_as_yes"
          radio_option_yes(value)

        when "loans against a life insurance policy_as_no"
          radio_option_no_last(value)

        when "current balance of any loans against life insurance"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 0.5
          enter_div_h3_div(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))
          browser.send_keys(:page_down)
          save_continue()
          browser.send_keys(:page_down)

        when "Finanical Data_Stocks Bonds_as_yes"
          radio_option_yes(value)

        when "Finanical Data_Stocks Bonds_as_no"
          radio_option_no_last(value)

        when "Finanical Data_Real Estate Primary_as_yes"
          radio_option_yes(value)

        when "Finanical Data_Real Estate Primary_as_no"
          radio_option_no_last(value)

        when "Financial Data_Real Estate Other_as_yes"
          radio_option_yes(value)

        when "Financial Data_Real Estate Other_as_no"
          radio_option_no_last(value)

        when "own any vehicles_as_yes"
          radio_option_yes(value)

        when "own any vehicles_as_no"
          radio_option_no_last(value)

        when "other personal property or assets_as_yes"
          radio_option_yes(value)

        when "other personal property or assets_as_no"
          radio_option_no_last(value)

        when "any notes payable or other liabilities_as_yes"
          radio_option_yes(value)

        when "any notes payable or other liabilities_as_no"
          radio_option_no_last(value)

        when "Assessed Taxes that were unpaid_as_yes"
          radio_option_yes(value)

        when "Assessed Taxes that were unpaid_as_no"
          radio_option_no_last(value)

        when "Please explain why you made this choice."
          enter_div_text(key, value)

        when "Save and Continue"
          browser.article(:class => "usa-width-two-thirds".split).inspect
          browser.article(:class => "usa-width-two-thirds".split).click
          # screen_shot()
          save_continue()

        when "Life Insurance Save and Continue"
          browser.article(:class => "usa-width-two-thirds".split).inspect
          browser.article(:class => "usa-width-two-thirds".split).click
          #screen_shot()
          save_continue_life_insurance()

        when "Complete Status"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          value1 = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          value2 = input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          sleep 0.3
          search_result_present(value1, value2)

        when "Submit"
          continue_submit(value)

        when "Success"
          assert_complete_section(key, value)

        when "Review left navigation"
          contributor_review(value)

        when "Review Submit"
          contributor_submit()
          alert_accept()

        when "Signature"
          browser.div(:class => "signature-section".split).parent.label(:for => "legal_0").wait_until_present(timeout: 10).click
          signed_accept()

        when "Initial Application"
          status_initial_application(key, value)


        else
          #  implement logic later "ERROR<<<FAILED>>>Missing element locator for  :  #{key}"
        end
      end
    end
  end

  def complete_all_contributor_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)

      case string2

      when "General Information"
        complete_contributor_section(string2, "Gender")
        complete_contributor_section(string2, "Marital Status")
        complete_contributor_section(string2, "Social Security Number")
        complete_contributor_section(string2, "Contact Information")
        complete_contributor_section(string2, "Current Home Address")
        complete_contributor_section(string2, "Length of residency")
        complete_contributor_section(string2, "Date and Place of Birth")
        complete_contributor_section(string2, "US Citizenship")

      when "Spouse General Information"
        complete_contributor_section(string2, "Spouse Gender")
        complete_contributor_section(string2, "Spouse Marital Status")
        complete_contributor_section(string2, "Spouse Social Security Number")
        complete_contributor_section(string2, "Spouse Contact Information")
        complete_contributor_section(string2, "Spouse Current Home Address")
        complete_contributor_section(string2, "Role in Applicant Firm")
        complete_contributor_section(string2, "Spouse Length of residency")
        complete_contributor_section(string2, "Spouse Date and Place of Birth")
        complete_contributor_section(string2, "Spouse Citizenship")

      when "Resume"
        complete_contributor_section(string2, "Upload Resume")

      when "Ownership and Control"
        complete_contributor_section(string2, "Applicant Firm Ownership")
        complete_contributor_section(string2, "Bank Account Access")
        complete_contributor_section(string2, "Full Time Devotion")
        complete_contributor_section(string2, "Business Affiliations")

      when "Spouse Ownership and Control"
        complete_contributor_section(string2, "Applicant Spouse Firm Ownership")
        complete_contributor_section(string2, "Spouse Bank Account Access")
        complete_contributor_section(string2, "Spouse Prior Ownership")
        complete_contributor_section(string2, "Spouse Business Affiliations")

      when "Prior 8(a) Involvement"
        complete_contributor_section(string2, "Prior 8a Involvement")
        complete_contributor_section(string2, "Federal Employment")
        complete_contributor_section(string2, "Household Federal Employment")


      when "Spouse Prior 8(a) Involvement"
        complete_contributor_section(string2, "Spouse Prior 8a Involvement")
        complete_contributor_section(string2, "Spouse Federal Employment")

      when "Character"
        complete_contributor_section(string2, "Financial")
        complete_contributor_section(string2, "Criminal History")
        complete_contributor_section(string2, "Criminal History Documentation")

      when "Spouse Character"
        complete_contributor_section(string2, "Spouse Financial")
        complete_contributor_section(string2, "Spouse Criminal History")
        complete_contributor_section(string2, "Spouse Criminal History Documentation")

      when "Basis of Disadvantage"
        complete_contributor_section(string2, "Basis of disadvantage")
        complete_contributor_section(string2, "Native American Documentation")

      when "Economic Disadvantage"
        complete_contributor_section(string2, "Transferred Assets")
        complete_contributor_section(string2, "Tax Returns")
        complete_contributor_section(string2, "Cash On Hand")
        complete_contributor_section(string2, "Other Sources Of Income")
        complete_contributor_section(string2, "Notes Receivable")
        complete_contributor_section(string2, "Retirement Accounts")
        complete_contributor_section(string2, "Life Insurance")
        complete_contributor_section(string2, "Stocks & Bonds")
        complete_contributor_section(string2, "Real Estate - Primary Residence")
        complete_contributor_section(string2, "Real Estate - Other")
        complete_contributor_section(string2, "Personal Property")
        complete_contributor_section(string2, "Notes Payable and Other Liabilities")
        complete_contributor_section(string2, "Assessed Taxes")
        complete_contributor_section(string2, "Personal Summary")
        complete_contributor_section(string2, "Privacy Statements")

      when "Spouse Economic Disadvantage"
        complete_contributor_section(string2, "Spouse Tax Returns")
        complete_contributor_section(string2, "Cash On Hand")
        complete_contributor_section(string2, "Other Sources Of Income")
        complete_contributor_section(string2, "Notes Receivable")
        complete_contributor_section(string2, "Retirement Accounts")
        complete_contributor_section(string2, "Life Insurance")
        complete_contributor_section(string2, "Stocks & Bonds")
        complete_contributor_section(string2, "Real Estate - Primary Residence")
        complete_contributor_section(string2, "Real Estate - Other")
        complete_contributor_section(string2, "Personal Property")
        complete_contributor_section(string2, "Notes Payable and Other Liabilities")
        complete_contributor_section(string2, "Assessed Taxes")
        complete_contributor_section(string2, "Personal Summary")
        complete_contributor_section(string2, "Privacy Statements")

      when "Multiple Contributors Creation"
        complete_contributor_section(string2, "Contributors_A")
        complete_contributor_section(string2, "Contributors_B")
        complete_contributor_section(string2, "Contributors_C")

      when "Review Submit"
        complete_contributor_section(string2, "Review Complete")

      when "Signature"
        complete_contributor_section(string2, "Signed")

      end
    end
  end
end