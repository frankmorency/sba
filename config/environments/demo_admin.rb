Rails.application.configure do
  config.serve_static_files = false
  config.assets_compile = true
  config.assets.debug = false
  config.assets.digest = true
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  # config.action_view.raise_on_missing_translations = true
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  else
    config.logger = Logger.new('/var/log/rails/demo.log')
  end
  config.logger.level = :debug
end
