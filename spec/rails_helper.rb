# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
require 'simplecov-cobertura'
require 'simplecov/parallel'
require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::Codecov,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter
]

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join("..", "..", "..", ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start 'rails'
puts "required simplecov"


require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'factory_bot'
require 'yarjuf'
require 'shoulda-matchers'
require 'capybara-screenshot/rspec'
require 'chewy/rspec'
require 'codeclimate-test-reporter'
require "selenium/webdriver"

if Rails.env == 'test'
  # FOR am_i_eligible_spec AND DEBUGGING / WRITING FEATURE SPECS
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :chrome do |app|
  #   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  #     chromeOptions: { args: %w(disable-gpu) }
  # )

  Capybara::Selenium::Driver.new app,
    browser: :chrome
    # desired_capabilities: capabilities
  end

  Capybara.javascript_driver = :chrome

else
  # FOR BUILDS
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
  end

  Capybara.javascript_driver = :headless_chrome
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.default_max_wait_time = 12
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot::RSpec.add_link_to_screenshot_for_failed_examples = true

Dir[Rails.root.join('spec/spec_helpers/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include UserHelpers
  config.include SbaApplicationHelpers
  config.include Warden::Test::Helpers
  config.include FeatureHelpers
  config.include QuestionnaireHelpers
  config.include WorkflowHelpers

  config.use_transactional_fixtures = false
  config.use_transactional_examples = true

  config.infer_spec_type_from_file_location!

  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
  end

  config.include Devise::TestHelpers, type: :controller

  if Feature.active?(:elasticsearch)
    config.before(:suite) do
      Chewy.strategy(:bypass)
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end

