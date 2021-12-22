class LoginPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  element(:email) {|b| b.input(id: "user_email")}
  element(:password) {|b| b.input(id: "user_password")}
  element(:signin_button) {|b| b.input(id: "business_signin")}
  element(:email_Text) {|b| b.label(for: "user_email")}
  element(:accountid) {|b| b.button(id: "profileid")}
  element(:logoutid) {|b| b.ul(class: "usa-nav-submenu".split).parent.a(class: "usa-nav-link".split)}
  element(:continue) {|b| b.button(id: "submit")}
  element(:create_account) {|b| b.button(id: "form_submit")}

  def screen_shot(str)
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    opts = {:page_height_limit => 5000}
    path = "features/screenshots/Login_'#{str}'_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def yml_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'user_details.yml'
  end

  def comp_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'comp_details.yml'
  end

  def login(username = "", passwd = "")
    email.set username
    password.set passwd
    signin_button.wait_until_present(timeout: 10).click
  end

  def login_yml(options = {})
    options = options.with_indifferent_access
    options.to_hash.reverse_merge! data_yml_hash.with_indifferent_access
    email.set data_yml_hash['username']
    password.set data_yml_hash['password']
    signin_button.wait_until_present(timeout: 10).click
  end

  def login_data_yml_test(str)
    $config_file = Dir.pwd + "features/libs/config/data"
    config_data = YAML.load(File.read($config_file + "/user_details.yml"))
    email_data = config_data[str]['username']
    pass_data = config_data[str]['password']
    email.wait_until_present(timeout: 10).send_keys(email_data.chomp)
    password.wait_until_present(timeout: 10).send_keys(pass_data.chomp)
    signin_button.wait_until_present(timeout: 10).click
  end

  def login_data_yml(str)
    email_data = data_yml[str]['username']
    pass_data = data_yml[str]['password']
    #puts "this name is :" + email_data
    #puts "this password is :" + pass_data
    email.wait_until_present(timeout: 10).send_keys(email_data.chomp)
    password.wait_until_present(timeout: 10).send_keys(pass_data.chomp)
    #screen_shot(str)
    signin_button.wait_until_present(timeout: 10).click
  end

  # def login_enc_data_yml(str)
  #   email_data = data_yml[str]['username']
  #   pass_data = data_yml[str]['enc_password']
  #   enc_pass = Base64.decode64(pass_data)
  #   puts enc_pass
  #   #puts "this name is :" + email_data
  #   #puts "this password is :" + pass_data
  #   email.wait_until_present(timeout: 10).send_keys(email_data.chomp)
  #   password.wait_until_present(timeout: 10).send_keys(enc_pass.chomp)
  #   #screen_shot(str)
  #   signin_button.wait_until_present(timeout: 10).click
  # end

  def logout()
    logoutid.inspect
    logoutid.wait_until_present(timeout: 10).click
    browser.cookies.clear
    browser.refresh
    sleep 3
  end

  def total_logout()
    account()
    logout()
  end

  def company_info()
    company = browser.div(:class => "usa-width-one-whole".split).h2
    $my_company = company.text.strip
    value = $my_company.gsub(/([\w\s]{30}).+/, '\1')
    # puts "#{value}"
    new_value = value.split("(")
    new_value.size.times do |i|
    end
    d = YAML::load_file('Features/libs/config/data/comp_details.yml')
    d['Company'].delete('Name')
    File.open('features/libs/config/data/comp_details.yml', 'w') {|f| f.write d.to_yaml}
    d['Company']['Name'] = "#{new_value[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')}".strip
    File.open('features/libs/config/data/comp_details.yml', 'w') {|f| f.write d.to_yaml}
  end

  def account()
    accountid.wait_until_present(timeout: 10).click
  end

  def complete_login_actions(string1, string2)
    iterate_array_type = data_yml_hash[string1]
    iterate_array_values = iterate_array_type.split(",")
    if in_array?(iterate_array_values, string2)
      my_data = data_yml_hash[string2]
      my_data.each do |key, value|

        case key

        when "Register"
          input_string = value.split(",")
          input_string.size.times do |i|
          end
          browser.div(:id => "leftborder").parent.input(:id => "user_first_name").wait_until_present(timeout: 10).send_keys input_string[0..0]
          browser.div(:id => "leftborder").parent.input(:id => "user_last_name").wait_until_present(timeout: 10).send_keys input_string[1..1]
          browser.div(:id => "leftborder").parent.input(:id => "user_email").wait_until_present(timeout: 10).send_keys input_string[2..2]
          browser.div(:id => "leftborder").parent.input(:id => "user_confirm_email").wait_until_present(timeout: 10).send_keys input_string[2..2]
          continue.wait_until_present(timeout: 10).click

        when "Strong Password"
          browser.div(:id => "leftborder").parent.input(:id => "user_password").wait_until_present(timeout: 10).send_keys value
          browser.div(:id => "leftborder").parent.input(:id => "user_password_confirmation").wait_until_present(timeout: 10).send_keys value
          browser.div(:class => "usa-width-one-whole".split).parent.label(:class => "iaccept".split).wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)
          sleep 1
          frame = browser.iframe(index: 0)
          # puts frame.text
          if frame.text.include? "I'm not a robot"
            frame.click
            sleep 5
            create_account.wait_until_present(timeout: 10).click
            sleep 5
          end
          sleep 1
          browser.window(:index => 0).use

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
          browser_status()
          inputx = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          c = browser.form(:action => /#{inputx}/).fieldset
          c.parent.input(:id => "contributor_full_name").wait_until_present(timeout:30).send_keys input_string[2..2]

        when "Email"
          input_string = value.split(">")
          input_string.size.times do |i|
          end
          browser_status()
          inputy = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          c = browser.form(:action => /#{inputy}/).fieldset
          c.parent.input(:id => "contributor_email").wait_until_present(timeout:30).send_keys input_string[2..2]

        when "Send_Invitation"
          input_string = value.split(">")
          input_string.size.times do |i|
          end
          inputy = input_string[0..0].to_s.gsub(/\"/, '\'').gsub(/[\[\]]/, '').gsub("'", '')
          c = browser.form(:action => /#{inputy}/).fieldset
          c.parent.input(:value => "Send invitation to collaborate", :name => "commit", :type => "submit").wait_until_present(timeout: 30).click
          browser_status()
          browser.refresh

        else
          raise "Missing action for Browser step: " +key

        end
      end
    end
  end

  class << self
    attr_accessor :company_info

  end
end


