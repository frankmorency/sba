class OverviewPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:signature_continue_button) {|b| b.input(id: "accept-button", :value => "Accept")}

  def screen_shot()
    opts = {:page_height_limit => 5000}
    path = "features/screenshots/Accept_Signature_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'overview_details.yml'
  end

  def signed_accept()
    signature_continue_button.wait_until_present(timeout: 10).click
    alert_accept()
  end

  def assert_new_section(value)
    browser.link(:text => "#{value}").text.include? value
  end

  def assert_new_section_iterate(value)
    iterate_array_type = data_yml_hash["Expected sections that are added"]
    iterate_array_values = iterate_array_type.split(",")
    #puts iterate_array_values
    iterate_given_values = value.split(",")
    #puts iterate_given_values
    for i in 0..100
      for j in 0..100
        if iterate_array_values[i] == iterate_given_values[j]
          browser.link(:text => "#{iterate_array_values[i]}").text.include? iterate_given_values[j]
          # puts " #{iterate_given_values[j]} :>><<: #{iterate_array_values[i]}"
        end
      end
    end
  end

  def new_section_click(key, value)
    iterate_array_type = data_yml_hash["Expected sections that are added"]
    iterate_array_values = iterate_array_type.split(",")
    #puts iterate_array_values
    iterate_given_values = key.split(",")
    #puts iterate_given_values
    for i in 0..10
      if iterate_array_values[i] == iterate_given_values[0]
        browser.link(:text => "#{value}").wait_until_present(timeout: 10).click
        # puts " #{iterate_given_values[j]} :>><<: #{iterate_array_values[i]}"
      end
    end
  end

  def overview_selection(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key

        when "New Section Added"
          assert_new_section_iterate(value)

        when "Character"
          new_section_click(key, value)

        when "Business Ownership"
          new_section_click(key, value)

        when "Individual Contributors"
          new_section_click(key, value)

        when "Contributors"
          new_section_click(key, value)

        when "Potential for Success"
          new_section_click(key, value)

        when "Control"
          new_section_click(key, value)

        when "Start Application"
          #  screen_shot()
          browser.a(:text => "#{value}").inspect
          browser.a(:text => "#{value}").wait_until_present(timeout: 10).click

        when "Check status of application"
          browser_status()
          browser.form(:class =>"button_to".split).parent.input(:value => "Review and sign",:class => "usa-button disabled".split).present?

        when "Final status of application"
          review_box = browser.h2(:text => "#{value}")
          review_box.inspect
          review_box.present?
          sign_submit = review_box.element(:xpath => './following::div')
          sign_submit.inspect
          sign_submit.parent.input(:value => "Sign and submit").present?

        when "Send 15 day returned completed"
          review_box = browser.h2(:text => "#{value}")
          review_box.inspect
          review_box.present?
          # sign_submit = review_box.element(:xpath => './following::div')
          # sign_submit.inspect
          browser.form(:class => "button_to".split).present?
          browser.form(:class => "button_to".split).wait_until_present(timeout: 30).click
          review_button = browser.label(:for => "legal_0")
          review_button.inspect
          review_button.wait_until_present(timeout: 30).click
          signed_accept()


        when "Annual Review Send deficiency letter 15 day returned completed"
          review_box = browser.h2(:text => "#{value}")
          review_box.inspect
          review_box.present?
          # sign_submit = review_box.element(:xpath => './following::div')
          # sign_submit.inspect
          browser.form(:class => "button_to".split).present?
          browser.form(:class => "button_to".split).wait_until_present(timeout: 30).click
          review_button = browser.label(:for => "legal_0")
          review_button.inspect
          review_button.wait_until_present(timeout: 30).click
          review_button2 = browser.label(:for => "legal_1")
          review_button2.inspect
          review_button2.wait_until_present(timeout: 30).click
          review_button3 = browser.label(:for => "legal_2")
          review_button3.inspect
          review_button3.wait_until_present(timeout: 30).click
          signed_accept()


        when "Accept"
          #  screen_shot()
          browser.input(:class => "accept_button".split, :value => "#{value}").inspect
          browser.input(:class => "accept_button".split, :value => "#{value}").wait_until_present(timeout: 30).click
          sleep 5

        when "Review and Sign"
          # screen_shot()
          review_box = browser.h2(:text => "#{value}")
          review_box.inspect
          sign_submit = review_box.element(:xpath => './following::div')
          sign_submit.inspect
          sign_submit.parent.input(:value => "Sign and submit").wait_until_present(timeout: 30).click
          #  screen_shot()
          review_button = browser.label(:for => "legal_0")
          review_button.inspect
          review_button.wait_until_present(timeout: 30).click
          signed_accept()
          #  screen_shot()
          browser.h3(:class => "usa-alert-heading".split).text.include? "Success"
          browser.p(:class => "usa-alert-text".split).text.include? "Your application has been submitted"


        when "Review Multiple Sign"
          review_box = browser.h2(:text => "#{value}")
          review_box.inspect
          sign_submit = review_box.element(:xpath => './following::div')
          sign_submit.inspect
          sign_submit.parent.input(:value => "Sign and submit").wait_until_present(timeout: 30).click
          review_button("legal_0")
          review_button("legal_1")
          review_button("legal_2")
          signed_accept()
          browser_status()
          browser.h3(:class => "usa-alert-heading".split).text.include? "Success"
          browser.p(:class => "usa-alert-text".split).text.include? "Your application has been submitted"


          # else
          #        puts "Missing element locator for  :  #{key}"
        end
      end
    end
  end

end
