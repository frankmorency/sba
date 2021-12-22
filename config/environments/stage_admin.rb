Rails.application.configure do
  config.serve_static_files = false
  config.assets_compile = true
  config.assets.debug = false
  config.assets.digest = true
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  #config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  else
    config.logger = Logger.new('/var/log/rails/stage.log')
  end
  config.logger.level = :debug
end
