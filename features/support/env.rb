require 'watir'
require 'rspec'
require 'require_all'
require 'nokogiri'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext'
require 'simplecov'
require 'simplecov-rcov'
require 'simplecov-cobertura'

SimpleCov.formatters = [
    #   SimpleCov::Formatter::HTMLFormatter,
    #   SimpleCov::Formatter::RcovFormatter
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
]

SimpleCov.start

require './features/libs/page_helper'
require './features/libs/data_helper'
require_all './features/libs/pages'

World PageHelper
World DataHelper

require 'selenium-webdriver'
require 'watir'
require 'yaml'
require 'base64'
require 'watir-screenshot-stitch'

$config_file = Dir.pwd + "/features/support"

config_data = YAML.load(File.read($config_file + "/config.yaml"))
browser_type = config_data['browser']
#puts browser_type

case ENV['BROWSER'] = browser_type

  when "firefox"
    browser = Watir::Browser.new :firefox
    INDEX_OFFSET = -1
    WEBDRIVER = true

  when "chrome"
    browser = Watir::Browser.new :chrome
    INDEX_OFFSET = -1
    WEBDRIVER = true

  when "phantomjs"
    browser = Watir::Browser.new :phantomjs
    INDEX_OFFSET = -1
    WEBDRIVER = true

  when "chrome-remote"
    browser = Watir::Browser.new :chrome, :switches => %w[--headless]
    INDEX_OFFSET = -1
    WEBDRIVER = true

  else
    raise "Missing driver for Browser instantiation: " + ENV['BROWSER'].to_s

end

require 'date'

Before do
  @browser = browser
  d = DateTime.now
  d.strftime("%d/%m/%Y %H:%M")
  d.strftime("%m/%d/%Y")
 # puts d.strftime("%m/%d/%Y")
end

# AfterStep do
#   now = Time.new
#   puts "Step duration: #{((now - @last_time)*100).round} ms"    # if (now-@last_time) > 10
#   @last_time = now
#
#     Dir::mkdir('screenshots') if not File.directory?('screenshots')
#     opts = { :page_height_limit => 5000 }
#     screenshot = "./screenshots/PASSED_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
#     @browser.screenshot.save_stitch(screenshot, @browser, opts)
#     # @browser.driver.save_screenshot(screenshot)
#     embed screenshot, 'image/png'
# end

After do |scenario|
  if scenario.failed?
    Dir::mkdir('features/screenshots') if not File.directory?('features/screenshots')
    opts = { :page_height_limit => 5000 }
    screenshot = "features/screenshots/FAILED_#{scenario.name.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    @browser.screenshot.save_stitch(screenshot, @browser, opts)
    # @browser.driver.save_screenshot(screenshot)
    embed screenshot, 'image/png'
  end
end

at_exit do
  ENV['ARCHIVE_RESULTS'] = 'no' if ENV['ARCHIVE_RESULTS'].nil?
  if ENV['ARCHIVE_RESULTS'] == "yes"
    Dir.mkdir("resultsarchive") if Dir["resultsarchive"].empty?
    folder = Dir.pwd
    input_filenames = ['results.html']

    zipfile_name = "#{Date.today}_results.zip"

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, folder + '/' + filename)
      end
    end
    FileUtils.mv(zipfile_name, "resultsarchive/#{zipfile_name}")
  end
  browser.cookies.clear
  browser.quit
end
