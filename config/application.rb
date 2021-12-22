require File.expand_path('../boot', __FILE__)

require "rails"

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Suppress annoying transactional callback deprecation warning
ActiveRecord::Base.raise_in_transactional_callbacks = true

Bundler.require(*Rails.groups)

module SbaApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    #config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile += %w( pdf.js pdf.css public.css contracting_officer_full.js contracting_officer_full.css)
    config.autoload_paths += %W(#{config.root}/lib)
    #config.middleware.use PDFKit::Middleware
    config.middleware.use Rack::TempfileReaper
    config.middleware.use 'RequestLogger'

    config.action_mailer.smtp_settings = {
        :address => "email-smtp.us-east-1.amazonaws.com",
        :port => 587,
        :domain => "amazonaws.com",
        :user_name => ENV["AWS_SES_USERNAME"],
        :password => ENV["AWS_SES_PASSWORD"],
        :authentication => :login,
        :enable_starttls_auto => true
    }

    config.action_view.prefix_partial_path_with_controller_namespace = false

    config.action_mailer.delivery_method = :smtp

    # Add X-UA-Compatible HTTP Header -- https://msdn.microsoft.com/library/dn255001(v=vs.85).aspx
    config.action_dispatch.default_headers.merge!('X-UA-Compatible' => 'IE=edge,chrome=1')

    config.active_record.observers = :elastic_observer
  end
end
