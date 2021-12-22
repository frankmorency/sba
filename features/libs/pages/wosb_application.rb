class WosbApplication < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:add_document) {|b| b.div(class: "add-req-doc").parent.a(href: "javascript:void(0)")}
  element(:add_document_button) {|b| b.div(class: "add-req-doc-button").parent.a(href: "javascript:void(0)")}
  element(:associate_document_link) {|b| b.div(class: "doc-options").parent.button(:text => "Choose from document library")}
  element(:upload_document) {|b| b.div(class: "doc-options").parent.button(id: "doc-upload-button")}
  element(:upload_document_link) {|b| b.div(class: "dz-default dz-message").parent.a(id: "dz-select-eight_a_pos_taxes")}
  element(:upload_button) {|b| b.button(id: "attach", :text => "Upload")}
  element(:associate_button) {|b| b.button(id: "document_library_associate", :text => "Associate")}
  element(:save_continue_button) {|b| b.input(id: "section_submit_button", :value => "Continue")}


  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'wosb.yml'
  end

  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def wosb_review()
    element = browser.execute_script("return document.body")
    browser.execute_script("return arguments[0].tagName", element) #=> "BODY"
    wait = Selenium::WebDriver::Wait.new(timeout: 5) # seconds
    wait.until {browser.a(:id => "review")}
    browser.a(:id => "review", :class => "usa-current".split).wait_until_present(timeout: 10).click
  end

  def alert_accept()
    browser.alert.wait_until_present(timeout: 10).ok
  end

  def sign()
    legal_0 = browser.label(:for => "legal_0")
    legal_0.inspect
    legal_0.wait_until_present(timeout: 10).click
    browser.label(:for => "legal_1").wait_until_present(timeout: 10).click
    browser.label(:for => "legal_2").wait_until_present(timeout: 10).click
    browser.label(:for => "legal_3").wait_until_present(timeout: 10).click
    browser.label(:for => "legal_4").wait_until_present(timeout: 10).click
    browser.label(:for => "legal_5").wait_until_present(timeout: 10).click
  end

  def eight_a_section(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|
        case key

        when "answers_8a_as_yes"
          radio_option_yes(value)

        when "answers_8a_as_yes_document"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          sleep 1
          document_original(input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[1..1].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), input_string[2..2].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

        when "Save and Continue"
          browser.article(:class => "usa-width-two-thirds".split).inspect
          browser.article(:class => "usa-width-two-thirds".split).click
          save_continue()

        when "Submit"
          continue_submit(value)

        when "Review left navigation"
          #wosb_review()
          browser.button(name:'commit').wait_until_present(timeout: 10).click
          alert_accept()
          sign()
          browser.button(name:'commit').wait_until_present(timeout: 10).click
        end
      end
    end
  end

  def view_certificate_letter()
    browser.link(:text =>"Certificate Letter").wait_until_present(timeout: 10).click
    browser.link(:text =>"Click to view and print certificate letter").wait_until_present(timeout: 10).click
    browser.window(:index => 1).use
    browser.window(:index => 0).use
  end
end
