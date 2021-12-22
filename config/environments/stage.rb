Rails.application.configure do
  config.serve_static_files = true
  config.assets_compile = true
  config.assets.debug = false
  config.assets.digest = true
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.eager_load = false
  config.consider_all_requests_local = false
  #config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.google_analytics_id = ENV["GOOGLE_ANALYTICS_ID"]
  config.force_ssl = false
  config.action_mailer.default_url_options = { host: "stg.certify.sba.gov" }
  Rails.application.routes.default_url_options[:host] = "stg.certify.sba.gov"
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  else
    config.logger = Logger.new("/var/log/rails/stage.log")
  end
  config.logger.level = ENV.fetch("RAILS_LOG_LEVEL", :warn)

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      s3_region: "us-east-1",
      bucket: ENV["S3_PUBLIC_BUCKET_NAME"],
    },
  }
end
