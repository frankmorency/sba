Rails.application.configure do
  # Setting to test cache store locally, disable one test is compelte
  config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

 
  # config.action_mailer.smtp_settings = {
  #   :address => "email-smtp.us-east-1.amazonaws.com",
  #   :port => 587,
  #   :domain => "amazonaws.com",
  #   :user_name => ENV["AWS_SES_USERNAME"],
  #   :password => ENV["AWS_SES_PASSWORD"],
  #   :authentication => :login,
  #   :enable_starttls_auto => true,
  # }

  # For using mailcatcher locally comment out the action_mailer.smtp_settings above
  # and uncomment the lines below. Change back before merging your branch
  # config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => '127.0.0.1', :port => 1025 }
  # config.action_mailer.raise_delivery_errors = false  

  # Make it work better with xray-rails gem
  config.assets.debug = true
  config.after_initialize do
    # PaperTrail.enabled = false
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

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end

  # if Rails.env != %w(production stage)

  # config.paperclip_defaults = {
  #   storage: :s3,
  #   :s3_permissions => "private",
  #   s3_credentials: {
  #     :bucket => "paperclip-lower",
  #     :access_key_id => "<unknown>",
  #     :secret_access_key => "<unknown>",
  #     :s3_region => "us-east-1",
  #   },
  # }

  config.paperclip_defaults = {
    storage: :s3,
    :s3_permissions => "private",
    s3_credentials: { :bucket => "paperclip-lower",
                      :access_key_id => ENV["PAPERCLIP_ACCESS_KEY_ID"],
                      :secret_access_key => ENV["PAPERCLIP_SECERT_KEY"],
                      :s3_region => "us-east-1" },
  }

  Paperclip::Attachment.default_options[:validate_media_type] = false

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
