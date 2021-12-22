class MailinatorPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  $config_file = Dir.pwd + "/features/support"
  config_data = YAML.load(File.read($config_file + "/config.yaml"))
  page_url config_data['web_mailinator_url']


  element(:check_any_inbox) {|b| b.input(id: "inboxfield")}
  element(:go_button) {|b| b.button(type: "button", text: "Go!")}
  element(:inbox_search) {|b| b.input(id: "inbox_field")}
  element(:inbox_button) {|b| b.span(id: "inbox_button").i()}
  element(:user_div_list) {|b| b.div(class: "lb_all_list")}
  element(:user_list) {|b| b.ul(class: "lb_all_sub-list")}
  element(:inbox_body) {|b| b.ul(class: "single_mail-body")}
  element(:empty_inbox) {|b| b.div(id: "publicm8rguy")}
# text: "           [ This Inbox channel is currently Empty ]"

  def screen_shot()
    opts = { :page_height_limit => 5000 }
    path = "features/screenshots/Mailinator_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def search_user(value)
    check_any_inbox.inspect
    check_any_inbox.wait_until_present(timeout: 10).click
    check_any_inbox.wait_until_present(timeout: 10).send_keys("#{value}")
    go_button.wait_until_present(timeout: 10).click
  end

  def search_all_users(value)
    input_string = value.split(",")
    input_string.size.times do |i|
      inbox_search.inspect
      inbox_search.wait_until_present(timeout: 10).click
      inbox_search.wait_until_present(timeout: 10).to_subtype.clear
      inbox_search.wait_until_present(timeout: 10).send_keys input_string[i..i]
      inbox_button.wait_until_present(timeout: 10).click
      inbox_search.wait_until_present(timeout: 10).click
      inbox_search.wait_until_present(timeout: 10).to_subtype.clear
    end
  end

  def confirm_users(value)
    input_string = value.split(",")
    input_string.size.times do |i|
      list = user_div_list.parent.li(:class => 'lb_all_item ng-scope')
      list.inspect
      list.elements(:class => "lb_all_sub-list".split).each do |usernames|
        #puts usernames.parent.div().text
        #  if input_string[i] == usernames.parent.div(:class => "lb_all_sub-item_text ng-binding").text
        #    usernames.text.include? input_string[i..i]
        #    usernames.parent.div(:class => "lb_all_sub-item_text ng-binding").click
        #  end
      end
    end
  end

  def click_link(key, value)
    container = browser.elements(class: "lb_all_sub-list".split)
    container.li(class: "lb_all_sub-item ".split).each do |is_text|
      #puts is_text
      # is_text.li(text: "#{key}").click
    end
  end

  def inbox_details(key, value)
    unique_element = browser.div(:class => "lb_all_list".split)
    unique_element.elements(:class => "lb_all_sub-list".split).each do |contribute_user|
      contribute_user.elements(:class => "lb_all_sub-item ".split).each do |contribute_list|
        if contribute_list.parent.div(:class => "lb_all_sub-item_text ng-binding".split).text == key
          contribute_list.parent.div(:class => "lb_all_sub-item_text ng-binding".split, :text => "#{key}").wait_until_present(timeout: 10).click
        end
      end
    end
  end

  def confirm_click(value)
    input_string = value.split(">")
    input_string.size.times do |i|
    end
    search_all_users(input_string[3..3].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''))

    unique_element = browser.div(class: "header-controls_desc2 ng-binding".split)
    str_observed = unique_element.text

    unique_elements = browser.ul(:id => "inboxpane")
    sleep 2
    new_links = browser.ul(:id => "inboxpane").lis.length
    # puts new_links

    if new_links == 0
      str_observed.include? input_string[1..1].to_s
      empty_inbox.text.include? input_string[0..0].to_s
      # puts "No Email found"

    elsif new_links > 0
      unique_elements.lis.each do |li|
        str_observed.include? input_string[1..1].to_s
        unique_li_elements = li
        searchtext = input_string[2..2].to_s
        sleep 2
        unique_li_elements.parent.div(:text => searchtext.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), :class => "all_message-min_text all_message-min_text-3".split).inspect
        unique_li_elements.parent.div(:text => searchtext.to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", ''), :class => "all_message-min_text all_message-min_text-3".split).wait_until_present(timeout: 30).click
        # puts "email found"
        break
      end
    end
  end

## mailinator api have limitations to delete the bulk email deletes
  def delete_click()
    unique_element = browser.div(class: "header-controls_desc2 ng-binding".split)
    str_observed = unique_element.text
    unique_elements = browser.ul(:id => "inboxpane")
    new_links = browser.ul(:id => "inboxpane").lis.length
    if new_links == 0
    elsif new_links > 0
      unique_elements.lis.each do |li|
        unique_li_elements = li
        sleep 0.1
        check_boxes = unique_li_elements.divs(:class => "all_message-min".split)
        sleep 0.1
        check_boxes.each do |c|
          box = c.parent.i(:class => "fa fa-square-o fa-lg".split)
          # box.wait_until_present(timeout: 10).click
          sleep 0.1
        end
      end
    end
    #browser.i(:class => "fa fa-trash fa-stack-1x fa-inverse").wait_until_present(timeout: 10).click
  end


  def register_contributor()
    sleep 5
#  	puts browser.iframe(:id => 'msg_body').link(:index => 0).text
    browser.iframe(:id => 'msg_body').link(:index => 0).wait_until_present(timeout: 10).click
    sleep 1
    browser.window(:index => 1).use
#browser.window(:index => 0).use
#browser.window(:index => 1).close
    sleep 1
  end

  def check_email_link()
    sleep 1
#   puts browser.iframe(:id => 'msg_body').link(:index => 0).text
    browser.iframe(:id => 'msg_body').link(:index => 0).wait_until_present(timeout: 10).click
    sleep 1
    browser.window(:index => 1).use
    browser.window(:index => 0).use
    browser.window(:index => 1).close
    sleep 1
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'mailinator_emails.yml'
  end

  def complete_actions(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key

        when "Search"
          search_user(value)

        when "More Contributors"
          search_all_users(value)

        when "contributor"
          confirm_click(value)

        when "test"
          confirm_click(value)

        when "email_link"
          check_email_link()

        when "sba_link"
          register_contributor()

        when "Delete Emails"
          delete_click()

        when "email_confirmation_link"
          check_email_link()


        end
      end
    end
  end
end
