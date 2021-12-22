require 'simplecov'

Rails.application.configure do
  # clean the existing coverage directory before writing the new results.
  Dir.foreach("coverage") do |file|
    next if [".",".."].include?(file)
    FileUtils.rm_rf(File.join("coverage",file), :verbose=>true)
  end if File.exists?('coverage')

  SimpleCov.start 'rails' do
    add_filter "/vendor/"
  end

  # Setting to test cache store locally, disable one test is compelte
  config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 1080 }
  config.action_mailer.default_options = { from: "my_address@example.com" }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Make it work better with xray-rails gem
  config.assets.debug = true
  config.after_initialize do
    #PaperTrail.enabled = false
    SecureHeaders::Configuration.default do |config|
      config.csp = {
          # directive values: these values will directly translate into source directives
          default_src: %w('self' 'unsafe-eval' 'unsafe-inline' *.newrelic.com *.nr-data.net *.google.com *.digitalgov.gov *.google-analytics.com *.gstatic.com *.atlassian.net),
          connect_src: %w(wws: https: 'self' data: *.google.com),
          img_src: %w(blob: https: 'self' *.google-analytics.com data:),
          font_src: %w('self' data:),
      }
    end
  end

  config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
          s3_region: 'us-east-1',
          bucket: ENV["S3_PUBLIC_BUCKET_NAME"],
          access_key_id: ENV["S3_PUBLIC_ACCESS_KEY"],
          secret_access_key: ENV["S3_PUBLIC_SECRET_KEY"]
      }
  }
end
