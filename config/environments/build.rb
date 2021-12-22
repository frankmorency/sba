Rails.application.configure do
  config.serve_static_files = false
  config.assets_compile = false
  config.assets.debug = false
  config.assets.digest = true
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.compile = true
  config.assets.debug = false
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    config.logger = Logger.new(STDOUT)
  else
    config.logger = Logger.new('/var/log/rails/build.log')
  end
  config.logger.level = :info

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      s3_region: 'us-east-1',
      bucket: ENV["S3_PUBLIC_BUCKET_NAME"]
    }
  }

end
