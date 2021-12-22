class WelcomePage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:wosb) {|b| b.link(:text, "WOSB self-certification")}
  element(:edwosb) {|b| b.link(:text, "EDWOSB self-certification")}
  element(:mpp) {|b| b.link(:text, "All Small Business Mentor-Protégé agreement")}
  element(:eight_a) {|b| b.link(:text, "8(a) Initial Application")}
  element(:eight_a_annual_review) {|b| b.link(:text, "8(a) Annual Review")}
  element(:accept_button_8a) {|b| b.input(:class => "accept_button".split)}

  def screen_shot()
    opts = {:page_height_limit => 5000}
    path = "./screenshots/Welcome_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def application_status_view(application, type, status, sub_date, exp_date, decision, action)
    certified = browser.div(:class => "usa-width-one-whole".split)
    table = certified.parent.table(:id => "certifications")
    if !table.trs.collect {|tr| tr[0].text == "#{application}"}.present?
      raise "No table is found with data"

    elsif table.trs.collect {|tr| tr[0].text == /#{application}/}.present?
      table.links.each do |link|
        #puts link.text
        if !link.text == "#{var}"
          puts "Trying to find the case"
        elsif link.text.include? "#{application}"
          puts "case found"
          app_type = link.element(:xpath => './following::td').text.strip
          app_status = link.element(:xpath => './following::td/following::td').text.strip
          app_submission = link.element(:xpath => './following::td/following::td/following::td').text.strip
          app_expiration = link.element(:xpath => './following::td/following::td/following::td/following::td').text.strip
          app_decision = link.element(:xpath => './following::td/following::td/following::td/following::td/following::td').text.strip
          app_action = link.element(:xpath => './following::td/following::td/following::td/following::td/following::td/following::td').text.strip
          app_type == "#{type}"
          app_status == "#{status}"
          app_submission == "#{sub_date}"
          app_expiration == "#{exp_date}"
          app_decision == "#{decision}"
          app_action == "#{action}"
          browser_status()
        end
      end
    end
  end

  def delete_initial_application (string1, string2, string3)
    sleep 0.5
    unique_element = browser.table(:id => "certifications").tbody.tr.td(:text => "#{string1}")
    if parent_element = unique_element.parent
      col1 = parent_element.td(:index => 0).text
      col2 = parent_element.td(:index => 1).text
      col3 = parent_element.td(:index => 2).text
      if col1 == "#{string1}" and col2 == "#{string2}"
        parent_element.td(:index => 6).a().click
        alert_accept()
      end
    end
  end


  def eight_a_annual_review
    unique_element_dashboard = browser.a(:href => "/vendor_admin/dashboard")
    unique_element_dashboard.wait_until_present(timeout: 10).click
  end

  def new_page_click()
    unique_element_dashboard = browser.a(:href => "/vendor_admin/dashboard")
    unique_element_dashboard.wait_until_present(timeout: 10).click
  end

  def dashboard_user(user)
    unique_element_dashboard = browser.a(:href => "/#{user}/dashboard")
    unique_element_dashboard.wait_until_present(timeout: 10).click
    browser_status()
  end

  def initial_fill()
    unique_element_1 = browser.table(:id => "certifications").tbody.tr
    parent_element_1 = unique_element_1.parent
    href_string = parent_element_1.a.href
    input_string = href_string.split("/")
    input_string.size.times do |i|
    end
    @varx = input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
    @var2 = "/sba_applications/".concat("#{@varx}").concat("/fill")
    $config_file = Dir.pwd + "/features/support"
    config_data = YAML.load(File.read($config_file + "/config.yaml"))
    @url = config_data['web_url'].concat("#{@var2}")
    # puts  @var2
    # puts  @url
    @browser.goto @url
  end

  def initial_ar_fill()
    browser_status()
    href_string = browser.url
    input_string = href_string.split("/")
    input_string.size.times do |i|
    end
    @varx = input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
    @var2 = "/sba_applications/".concat("#{@varx}").concat("/fill")
    $config_file = Dir.pwd + "/features/support"
    config_data = YAML.load(File.read($config_file + "/config.yaml"))
    @url = config_data['web_url'].concat("#{@var2}")
    # puts  @var2
    # puts  @url
    @browser.goto @url
    browser_status()
  end

  def vendor_admin_fill()
    browser_status()
    sleep 5
    href_string = browser.url
    sleep 5
    #puts href_string
    input_string = href_string.split("/")
    input_string.size.times do |i|
    end
    browser_status()
    @varx = input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
    @var2 = "/sba_applications/".concat("#{@varx}").concat("/fill")
    $config_file = Dir.pwd + "/features/support"
    config_data = YAML.load(File.read($config_file + "/config.yaml"))
    @url = config_data['web_url'].concat("#{@var2}")
    # puts  @var2
    # puts  @url
    browser_status()
    @browser.goto @url until browser_status()
    puts "Completed the autofill"
    browser_status()
  end

  def vendor_create_annual_review()
    browser_status()
    href_string = browser.url
    #puts href_string
    input_string = href_string.split("/")
    input_string.size.times do |i|
    end
    @varx = input_string[4..4].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
    @var2 = "/sba_applications/".concat("#{@varx}").concat("/create_annual_review")
    $config_file = Dir.pwd + "/features/support"
    config_data = YAML.load(File.read($config_file + "/config.yaml"))
    @url = config_data['web_url'].concat("#{@var2}")
    # puts  @var2
    # puts  @url
    @browser.goto @url
    browser_status()
  end

  def assert_complete_section(key, value)
    browser_status()
    browser.h3(:class => "usa-alert-heading".split).text.include? key
    browser.p(:class => "usa-alert-text".split).text.include? value
    browser_status()
  end

  def active_wosb_application
    browser.table(:text => "WOSB Self-Certification")
    browser.table(:text => "Certificate")
    browser.table(:text => "Active")
    browser.table(:text => "Self Certified")
    browser.table(:text => "Self Certified")
  end

  def view_summary
    browser.link(:text => "WOSB Self-Certification").wait_until_present(timeout: 10).click
    browser.text.include?("Women-Owned Small Business Program Self-Certification Summary").should == true
  end

  def click_application(type, status)
    sleep 0.5
    certifications = browser.table(:id => "certifications")
    table = certifications.parent.tbody
    if table.trs.find {|tr| tr[1].text == "#{type}" && tr[2].text == "#{status}"}.present?
      row = table.trs.find {|tr| tr[1].text == "#{type}" && tr[2].text == "#{status}"}
      row.td(:index => 0).a.click
      browser_status()
      browser.form(:class =>"button_to".split).parent.input(:value => "Review and sign",:class => "usa-button disabled".split).present?
      browser_status()
    else
      raise "Application is in different status"
    end
  end

  def click_complete_application(type, status)
    sleep 0.5
    certifications = browser.table(:id => "certifications")
    table = certifications.parent.tbody
    if table.trs.find {|tr| tr[1].text == "#{type}" && tr[2].text == "#{status}"}.present?
      row = table.trs.find {|tr| tr[1].text == "#{type}" && tr[2].text == "#{status}"}
      row.td(:index => 0).a.click
      browser_status()
      review_box = browser.h2(:text => "Your application package is ready to submit!")
      review_box.inspect
      review_box.present?
      sign_submit = review_box.element(:xpath => './following::div')
      sign_submit.inspect
      sign_submit.parent.input(:value => "Sign and submit").present?
    else
      raise "Application is in different status"
    end
  end
end
