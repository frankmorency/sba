class GmailContributorPage < GenericBasePage
  include DataHelper
  include PageActions

  element(:email) {|b| b.input(id: "identifierId")}
  element(:password) {|b| b.input(name: "password")}
  element(:next_button) {|b| b.span(:text => "Next")}

  $config_file = Dir.pwd + "/features/support"
  config_data = YAML.load(File.read($config_file + "/config.yaml"))
  page_url config_data['web_gmail_url']

  def login_enc_data_yml(str)
    email_data = data_yml[str]['username']
    pass_data = data_yml[str]['enc_password']
    email.wait_until_present(timeout: 10).send_keys(email_data.chomp)
    next_button.wait_until_present(timeout: 10).click
    password.wait_until_present(timeout: 10).send_keys(pass_data.chomp)
    next_button.wait_until_present(timeout: 10).click
    browser_status()
    sleep 2
    browser.a(:text => /Inbox/).wait_until_present(timeout: 10).click
    checkbox()
    browser_status()
    browser.execute_script('window.open("")')
    browser.window(:index => 0).use
    browser.window(:index => 1).use
    browser_status()
  end

  def delete_email()
    browser_status()
    divs = browser.elements(:css => 'div.ar9.T-I-J3.J-J5-Ji')
    if divs.present?
      divs.each do |e|
        if e.present?
          e.wait_until_present(timeout: 30).click
          break
        end
      end
    end
  end

  def checkbox()
    browser.a(:text => /Inbox/).wait_until_present(timeout: 10).click
    divs = browser.elements(:css => 'div.T-Jo-auh')
    if divs.present?
      divs.each do |e|
        e.click
        delete_email()
        break
      end
    end
  end

  def email_click(str)
    browser.window(:index => 1).use
    browser_status()
    browser.window(:index => 0).use
    browser.a(:text => /Inbox/).wait_until_present(timeout: 10).click
    browser_status()
    browser.span(:text => /#{str}/).click
    browser.element(:link => "Activate Account").click
    sleep 5
    browser.window(:index => 0).use
    browser_status()
    checkbox()
    browser_status()
    browser.window(:index => 2).close
    browser_status()
    browser.window(:index => 1).use
  end

  def clean_up_junk_emails()
    browser.window(:index => 1).use
    browser_status()
    browser.window(:index => 0).use
    browser_status()
    checkbox()
    browser_status()
    checkbox()
    browser_status()
    browser.window(:index => 0).use
    browser_status()
    browser.window(:index => 1).use
  end

  def confirm_registration_delete_email(str)
    browser.window(:index => 1).use
    browser_status()
    browser.window(:index => 0).use
    browser_status()
    email_click(str)
    browser_status()
    browser.window(:index => 0).use
    browser_status()
    checkbox()
    browser_status()
    browser.window(:index => 2).close
    browser_status()
    browser.window(:index => 1).use
  end

end