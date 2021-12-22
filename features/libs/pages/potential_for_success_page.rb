class PotentialForSuccessPage < GenericBasePage
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
  element(:save_continue_button) {|b| b.input(id: "section_submit_button", :value => "Continue")}

  def screen_shot()
    opts = { :page_height_limit => 5000 }
    path = "features/screenshots/PotentialForSuccess_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def click_associate_button()
    associate_button.wait_until_present(timeout: 10).click
  end

  def associate_key_value(key, value)
    ## refactor this
    browser.send_keys(:page_down)
    sleep 0.5
    button_associate = browser.h3(:text => "#{key}").parent.div(class: 'add-req-doc'.split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
    button_associate.wait_until_present(timeout: 10).click
    sleep 0.5
    buttons = browser.h3(:text => "#{key}").parent.div(class: 'options-box'.split).div(class: "doc-options".split).button(class: "usa-button-outline usa-button-active".split)
    buttons.wait_until_present(timeout: 10).click
    sleep 0.5
    browser.send_keys(:page_down)
    sleep 0.5
    document_check = browser.h3(:text => "#{key}").parent.table(class: 'display-table'.split).tbody().tr.td(id: "document_library_file_name").ul().li().label()
    document_check.wait_until_present(timeout: 10).click
    browser.h3(:text => "#{key}").parent.div(class: 'right-align'.split).div.button(id: "document_library_associate").wait_until_present(timeout: 10).click
    continue_submit("#{value}")
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

  def upload_file_original(key, _file)
    add_document.wait_until_present(timeout: 30).click
    sleep 0.5
    upload_document.wait_until_present(timeout: 30).click
    sleep 0.5
    upload_document_link.wait_until_present(timeout: 30).click
    file_location = data_pdf("#{_file}")
    sleep 0.5
    #   puts "upload is in progress#"
    @browser.file_field().set file_location
    sleep 0.5
    #   puts "upload is in progress###"
    @browser.table(:id => "file_list_append").parent.input(id: 'comment').wait_until_present(timeout: 10).send_keys "#{_file} : file uploaded"
    sleep 0.5
    upload_button.wait_until_present(timeout: 30).click
    sleep 0.5
    puts "upload is completed###"
    table = @browser.table(:id => "currently_attached")
    starting_row_index = browser.table.rows.to_a.index {|row| row.td(:id => "document_library_file_name", :text => "#{_file}").present?}
  end

  def associate_document_first(value, key, _file)
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
          associate_document_link.inspect
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

  def document_first(value, key, _file)
    begin
      associate_document_first(value, key, _file)
    end
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
    puts table.rows.length
    (starting_row_indexa).upto(table.rows.length - 1) {|x|
      #      puts browser.table[x][0].text
      if browser.table[x][0].text =="#{_file}"
        browser.table[x][0].click
        associate_button.wait_until_present(timeout: 10).click
#          puts "association is for this successful"
        sleep 0.5
        browser.h2(:text => "Revenue").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
        break
      end
    }

  end

  def associate_document(key, _file)
    associate_document_link.wait_until_present(timeout: 30).click
    sleep 0.5
    table = browser.table(:class => "display-table".split).wait_until_present(timeout: 30)
    sleep 0.5
    starting_row_index = table.rows.to_a.index {|row| row.td(:id => "document_library_file_name").present?}
    #  puts table.rows.length
    begin
      (starting_row_index).upto(table.rows.length - 1) {|x|
        #      puts browser.table[x][0].text
        if browser.table[x][0].text =="#{_file}"
          browser.table[x][0].click
          associate_button.wait_until_present(timeout: 10).click
          #        puts "association is successful"
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
    browser.a(:id => "eight_a_pos_taxes").wait_until_present(timeout: 30).click
    add_document.wait_until_present(timeout: 30).click
    begin
      associate_document(key, _file)
    end
  end

  def enter_values(value)
    input_string = value.split(",")
    input_string.size.times do |i|
    end
   # unique_element = browser.table(:class => "jsgrid-table".split).tbody.trs
   # puts unique_element
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell".split, :index => 0).input.wait_until_present(timeout: 10).send_keys(input_string[0..0])
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell".split, :index => 1).input.wait_until_present(timeout: 10).send_keys(input_string[1..1])
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell".split, :index => 2).input.wait_until_present(timeout: 10).send_keys(input_string[2..2])
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell".split, :index => 3).input.wait_until_present(timeout: 10).send_keys(input_string[3..3])
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell jsgrid-align-right".split, :index => 0).input.wait_until_present(timeout: 10).send_keys(input_string[4..4])
    browser_status()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row".split).td(:class => "jsgrid-cell jsgrid-control-field jsgrid-align-center".split).input(:class =>"jsgrid-button jsgrid-insert-button".split).wait_until_present(timeout: 10).click
    sleep 1
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
    browser_status()
   # browser.table(:class => "jsgrid-table".split).parent.tr(:class => "jsgrid-insert-row").td(:class => "jsgrid-cell", :index => 0).input.wait_until_present(timeout: 10).click
  end

  def continue()
    browser.h2(:text => "Taxes").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
    # browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
  end


  def potential_for_sucess_submit()
    $review_button = browser.input(:class => "review".split, :value => "Submit")
    $review_button.wait_until_present(timeout: 10).click
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'potential_for_success_details.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def complete_potential_for_success_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key
        when "Uploading Documents"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

        when "document_library_file_name"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))
          save_continue()

        when "primary NAICS code listed in SAM.gov_as_yes"
          radio_option_yes(value)

        when "primary NAICS code listed in SAM.gov_as_no"
          radio_option_no_last(value)

        when "Please explain why you made this choice."
          browser.div(:class => "comment required".split, :text => "#{key}").parent.textarea(:id => 'answers_630_comment').send_keys value

        when "primary NAICS code for at least two years_as_yes"
          radio_option_yes(value)

        when "primary NAICS code for at least two years_as_no"
          radio_option_no_last(value)

        when "primary NAICS code for at least two years_as_no_document"
          associate_document_original(key, _file)

        when "most recently completed fiscal year_as_percentage"
          browser.div(:class => "block_fields".split).parent.input(:id => 'answers_632_value').send_keys value

        when "contracts within the last 12 months_as_awards"
          enter_values(value)

        when "contracts within the last 12 months_as_awards reenter"
          enter_values(value)

        when "Please upload an interim or year-end balance sheet and profit and loss statement."
          refactor_this(value)


        when "are not commercial bank loans_as_yes"
          radio_option_yes(value)

        when "are not commercial bank loans_as_no"
          radio_option_no_last(value)

        when "are not commercial bank loans_as_yes_document"
          document(key, value)

        when "special licenses under which the applicant firm operates_as_yes"
          radio_option_yes(value)

        when "special licenses under which the applicant firm operates_as_no"
          radio_option_no_last(value)

        when "special licenses under which the applicant firm operates_as_yes_document"
          document(key, value)

        when "bonding ability from the applicant firms surety_as_yes"
          radio_option_yes(value)

        when "bonding ability from the applicant firms surety_as_no"
          radio_option_no(value)

        when "bonding ability from the applicant firms surety_as_not_applicable"
          radio_option_no_last(value)

        when "bonding ability from the applicant firms surety_as_yes_document"
          document(key, value)

        when "Save and Continue"
          #screen_shot()
          save_continue()

        when "Submit"
          continue_submit(value)

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
          potential_for_sucess_review(value)

        when "Submit Potential for Success"
          potential_for_sucess_submit()

          #      else
          #        puts "Missing element locator for  :  #{key}"
        end
      end
    end
  end
end