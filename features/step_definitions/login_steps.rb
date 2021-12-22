When("the {string} logged into the certify application") do |string|
  visit HomePage
  on(HomePage).sign_in.wait_until_present(timeout: 10).click
  on(LoginPage).login_data_yml(string)
end

Then("the profile for the {string} is displayed") do |string|
  on(LoginPage).account()
  on(LoginPage).logout()
end

Given("the {string} logged into the gmail account") do |string|
  visit GmailContributorPage
  on(GmailContributorPage).login_enc_data_yml(string)
end

Given("the {string} is registered into certify application") do |string|
#  pending # Write code here that turns the phrase above into concrete actions
end

Given("the {string} is on Mailinator site") do |string|
  visit MailinatorPage
end

When("the users verifies his {string} or {string} credentials") do |string, string2|
  on(MailinatorPage).complete_actions(string, string2)
end

def data_yml
  @data_yml = YAML.load(File.read "#{data_default_directory}/#{yml_file}")
end

def data_yml_hash
  @data_yml = YAML.load_file "#{data_default_directory}/#{yml_file}"
end

def yml_file
  ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'user_details.yml'
end

# only soft delete, can't delete all relationship with sql, REST destroy methods will be implemented in APP-2682
Given("the {string} as registered from the Mailinator site") do |string|
  visit RESTEndpointPage1
  visit HomePage
  visit RESTEndpointPage2
  visit HomePage
  visit RESTEndpointPage3
  visit HomePage
  visit RESTEndpointPage4
  visit HomePage
  visit RESTEndpointPage5
  visit HomePage
  visit RESTEndpointPage6
  visit HomePage
  @browser.a(:class => "logout").inspect
  @browser.a(:class => "logout").wait_until_present(timeout: 10).click
end


Then("the user confirms his {string} in the login inbox messages") do |string|
  case string

  when "credentials"
    on(MailinatorPage).complete_actions(string, "contributor_1")
    on(MailinatorPage).complete_actions(string, "contributor_2")
    on(MailinatorPage).complete_actions(string, "contributor_3")
    on(MailinatorPage).complete_actions(string, "test")

  when "Contributor A registration"
    on(MailinatorPage).complete_actions(string, "ContributorA")
    on(MailinatorPage).complete_actions(string, "Certify Registration Link")

  when "Contributor B registration"
    on(MailinatorPage).complete_actions(string, "ContributorB")
    on(MailinatorPage).complete_actions(string, "Certify Registration Link")

  when "Contributor C registration"
    on(MailinatorPage).complete_actions(string, "ContributorC")
    on(MailinatorPage).complete_actions(string, "Certify Registration Link")

  when "Contributor A removal notice"
    on(MailinatorPage).complete_actions(string, "Remove ContributorA Confirmation")
    on(MailinatorPage).complete_actions(string, "Delete Emails")

  when "Contributor B removal notice"
    on(MailinatorPage).complete_actions(string, "Remove ContributorB Confirmation")
    on(MailinatorPage).complete_actions(string, "Delete Emails")

  when "Contributor C removal notice"
    on(MailinatorPage).complete_actions(string, "Remove ContributorB Confirmation")
    on(MailinatorPage).complete_actions(string, "Delete Emails")

  when "SBA Contributor A registration"
    on(MailinatorPage).complete_actions(string, "ContributorA")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor A")
    on(MailinatorPage).complete_actions(string, "ContributorA Certify Email Confirmation Link")

  when "SBA Contributor B registration"
    on(MailinatorPage).complete_actions(string, "ContributorB")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor B")
    on(MailinatorPage).complete_actions(string, "ContributorB Certify Email Confirmation Link")

  when "SBA Contributor C registration"
    on(MailinatorPage).complete_actions(string, "ContributorC")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor C")
    on(MailinatorPage).complete_actions(string, "ContributorC Certify Email Confirmation Link")

  when "SBA Contributor A1 registration"
    on(MailinatorPage).complete_actions(string, "ContributorA1")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor A1")
    on(MailinatorPage).complete_actions(string, "ContributorA1 Certify Email Confirmation Link")

  when "SBA Contributor A2 registration"
    on(MailinatorPage).complete_actions(string, "ContributorA2")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor A2")
    on(MailinatorPage).complete_actions(string, "ContributorA2 Certify Email Confirmation Link")

  when "SBA Contributor B2 registration"
    on(MailinatorPage).complete_actions(string, "ContributorB2")
    on(MailinatorPage).complete_actions(string, "Certify Registration")
    visit HomePage
    on(HomePage).get_started.wait_until_present(timeout: 10).click
    on(LoginPage).complete_actions(string, "Contributor B2")
    on(MailinatorPage).complete_actions(string, "ContributorB2 Certify Email Confirmation Link")

  end

end