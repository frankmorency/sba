module PageActions

  private

  def alert_accept()
    begin
      browser.alert.wait_until_present(timeout: 10).ok
      browser_status()
      true
    rescue Watir::Wait::TimeoutError
      false
    end
  end

  def alert_deny()
    begin
      browser.alert.wait_until_present(timeout: 10).close
      browser_status()
      true
    rescue Watir::Wait::TimeoutError
      false
    end
  end

  def assert_complete_section(key, value)
    browser_status()
    browser.h3(:class => "usa-alert-heading".split).text.include? key
    browser.p(:class => "usa-alert-text".split).text.include? value
  end

  def browser_status()
    ready = browser.ready_state.eql? "complete"
    browser.wait unless ready
  end

  def click_accept_button(value)
    browser.input(class: "accept_button".split, value: "#{value}").wait_until_present(timeout: 30).click
    browser_status()
    # sleep 5
  end

  def click_annual_review_button(value)
    browser.input(class: "usa-button".split, value: "#{value}").wait_until_present(timeout: 30).click
    browser_status()
    # sleep 5
  end

  def continue_submit(value)
    browser.h2(:text => "#{value}").parent.input(id: 'section_submit_button').wait_until_present(timeout: 10).click
    browser_status()
    # browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
  end

  def dashboard_click()
    browser.a(:text => "Dashboard").wait_until_present(timeout:10).click
  end

  def dropdown_selection(key, value)
    #	browser.h3(:text => "#{key}").parent.select_list.selected_options.map(&:text)
    # browser.h3(:text => "#{key}").parent.select_list().option(:text, "#{value}").select
    browser_status()
    item = browser.h3(:text => "#{key}")
    item1 = item.element(:xpath => './following::div')
    item1.parent.select_list().option(:text, "#{value}").select
    browser_status()
  end

  def dropdown_label_selection(key, value)
    # browser.h3(:text => "#{key}").parent.select_list.selected_options.map(&:text)
    browser_status()
    unique_dropdown = browser.h3(:text => "#{key}")
    item1 = unique_dropdown.element(:xpath => './following::div')
    item1.parent.select_list().option(:value => "#{value}").wait_until_present(timeout: 30).select
    browser_status()
  end

  def enter_text(key, value)
    browser_status()
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.textarea().wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def enter_div_text(key, value)
    browser_status()
    unique_item = browser.div(:text => "#{key}")
    #  item = unique_item.element(:xpath => './following::div')
    unique_item.parent.textarea().wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def enter_div_class(key, value)
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:required => "required").wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def enter_div_id(key, value)
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:required => "required", :type => "number").wait_until_present(timeout: 30).click
    item.parent.input(:required => "required", :type => "number").send_keys("#{value}")
    browser_status()
  end

  def enter_div_id_h3(key, value)
    unique_item = browser.div(:id => key.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '')).fieldset().h3()
    unique_item.inspect
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:required => "required", :type => "number").inspect
    item.parent.input(:required => "required", :type => "number").wait_until_present(timeout: 30).click
    item.parent.input(:required => "required", :type => "number").send_keys("#{value}")
    browser_status()
  end

  def enter_div_h3_div(key, value)
    browser.send_keys(:page_down)
    unique_item = browser.div(:id => key.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '')).fieldset().div()
    unique_item.inspect
    item = unique_item.element(:xpath => './following::div')
    item.inspect
    item.parent.input(:required => "required", :type => "number").inspect
    item.parent.input(:required => "required", :type => "number").wait_until_present(timeout: 10).click
    item.parent.input(:required => "required", :type => "number").send_keys("#{value}")
    browser_status()
    sleep 0.5
  end

  def enter_input_text(key, value)
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:required => "required").wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def enter_calender_text(key, value)
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:placeholder => "mm/dd/yyyy").wait_until_present(timeout: 30).click
    item.parent.input(:placeholder => "mm/dd/yyyy").wait_until_present(timeout: 30).send_keys value
    unique_item.wait_until_present(timeout: 30).click
    sleep 2
    browser_status()
  end

  def enter_calender_div_class(key, value)
    unique_item = browser.h3(:text => "#{key}")
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:placeholder => "mm/dd/yyyy").wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def enter_calender_div_id(key, value)
    unique_item = browser.div(:id => key.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, ''))
    #  item = unique_item.element(:xpath => './following::div')
    unique_item.parent.input(:required => "required", :placeholder => "mm/dd/yyyy").inspect
    unique_item.parent.input(:required => "required", :placeholder => "mm/dd/yyyy").click
    unique_item.parent.input(:required => "required", :placeholder => "mm/dd/yyyy").send_keys("#{value}")
    browser_status()
  end

  def enter_calender_div_classy(key, value)
   # unique_item = browser.div(:class => key.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, ''))
    #  item = unique_item.element(:xpath => './following::div')
    browser.input(:class => "hasDatepicker", :placeholder => "mm/dd/yyyy").inspect
  #  browser.input(:class => "hasDatepicker", :placeholder => "mm/dd/yyyy").click
    browser.input(:class => "hasDatepicker", :placeholder => "mm/dd/yyyy").wait_until_present(timeout: 30).send_keys("#{value}")
    browser_status()
  end

  def enter_calender_index_text(key, value)
    unique_item = browser.h3(:index => "#{key}".to_i)
    item = unique_item.element(:xpath => './following::div')
    item.parent.input(:placeholder => "mm/dd/yyyy").wait_until_present(timeout: 30).send_keys value
    browser_status()
  end

  def frame_alert(value)
    begin
      browser.frame(:class, "view".split).button(:text, "#{value}").click
      browser_status()
    rescue Selenium::WebDriver::Error::UnhandledAlertError
      browser.alert.ok
      browser_status()
    end
  end

  def radio_option_yes(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        if item1.parent.label(:text => "Yes",class: 'yes'.split).present?
          item1.parent.label(:text => "Yes",class: 'yes'.split).wait_until_present(timeout: 10).click
          browser_status()
          break
        end
      end
    end
  end

  def radio_option_yes_special(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        if item1.parent.label(:text => "Yes",class: 'yes'.split).present?
          item1.parent.label(:text => "Yes",class: 'yes'.split).wait_until_present(timeout: 10).click
          save_continue()
          browser_status()
          break
        end
      end
    end
  end

  def radio_option_no(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        item1.parent.label(class: 'no'.split).wait_until_present(timeout: 10).click
        browser_status()
        break
      end
    end
  end

  def radio_option_no_last(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text == "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        item1.parent.label(class: 'no last'.split).wait_until_present(timeout: 10).click
        browser_status()
        break
      end
    end
  end

  def radio_option_index_yes(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        item1.parent.label(class: 'yes'.split).wait_until_present(timeout: 10).click
        browser_status()
        break
      end
    end
  end

  def radio_option_index_no(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        item1.parent.label(class: 'no'.split).wait_until_present(timeout: 10).click
        browser_status()
        break
      end
    end
  end

  def radio_option_index_no_last(value)
    item = browser.divs(:class => 'sba-c-question__primary-text'.split)
    item.each do |textloop|
      if textloop.text.include? "#{value}"
        item1 = textloop.element(:xpath => './following::div/div')
        item1.parent.label(class: 'no last'.split).wait_until_present(timeout: 10).click
        browser_status()
        break
      end
    end
  end

  def radio_option_true_index_yes(value)
    browser.h3(:index => "#{value}".to_i).parent.label(class: 'yes'.split).wait_until_present(timeout: 10).click
    browser_status()
  end

  def radio_option_true_index_no(value)
    browser.h3(:index => "#{value}".to_i).parent.label(class: 'no'.split).wait_until_present(timeout: 10).click
    browser_status()
  end

  def radio_option_true_index_no_last(value)
    browser.h3(:index => "#{value}".to_i).parent.label(class: 'no last'.split).wait_until_present(timeout: 10).click
    browser_status()
  end

  def review_button(label)
    review_button = browser.label(:for => "#{label}")
    review_button.inspect
    review_button.wait_until_present(timeout: 10).click
  end

  def save_and_submit()
    browser.input(id: "section_submit_button").wait_until_present(timeout: 10).click
    browser_status()
  end

  def save_continue()
    save_continue_button.inspect
    save_continue_button.wait_until_present(timeout: 10).click
    browser_status()
  end

  def search_result_present(key, value)
    browser_status()
    browser.a(:id => "#{key}", :class => "completed".split).inspect
    if browser.a(:id => "#{key}", :class => "completed".split).visible? && browser.a(:id => "#{key}", :class => "completed".split).present?
      browser.a(:id => "#{key}", :class => "completed".split).text.include? value
    end
  end

  def select_radio_values(key, value)
    unique_radio = browser.h3(:text => "#{key}")
    item1 = unique_radio.element(:xpath => './following::div')
    item1.parent.divs(:class => 'block'.split).each do |textloop|
      textloop.divs(:class => 'block_fields'.split).each do |item|
        inputx = item.input(:value => "#{value}")
        # puts input.text
        if inputx.exists?
          # puts inputx.element(:xpath => './following-sibling::label').text
          inputx.element(:xpath => './following-sibling::label').wait_until_present(timeout: 30).click
          browser_status()
        end
      end
    end
  end

  def string_truncate(length=100, ellipsis='.')
    self.length > length ? self[0..length].gsub(/\s*\S*\z/, '').rstrip+ellipsis : self.rstrip
  end

  class << self
    attr_accessor :alert_accept,
                  :alert_deny,
                  :assert_complete_section,
                  :browser_status,
                  :click_accept_button,
                  :click_annual_review_button,
                  :continue_submit,
                  :dashboard_click,
                  :dropdown_selection,
                  :dropdown_label_selection,
                  :enter_calender_div_class,
                  :enter_calender_div_classy,
                  :enter_calender_div_id,
                  :enter_calender_index_text,
                  :enter_calender_text,
                  :enter_div_class,
                  :enter_div_h3_div,
                  :enter_div_id,
                  :enter_div_id_h3,
                  :enter_div_text,
                  :enter_input_text,
                  :enter_text,
                  :frame_alert,
                  :select_radio_values,
                  :radio_option_yes,
                  :radio_option_no,
                  :radio_option_no_last,
                  :save_continue,
                  :save_and_submit,
                  :search_result_present,
                  :select_radio_values,
                  :string_truncate
  end

end