CertifyMessages.configure do |config|
  template = ERB.new File.new("#{Rails.root.to_s}/config/messages.yml").read
  processed = YAML.load template.result(binding)
  configuration = processed[Rails.env]
  config.api_url = configuration["api_url"]
  config.msg_api_version = configuration["msg_api_version"]
end

CertifyNotifications.configure do |config|
  template = ERB.new File.new("#{Rails.root.to_s}/config/notifications.yml").read
  processed = YAML.load template.result(binding)
  configuration = processed[Rails.env]
  config.api_url = configuration["api_url"]
end

# load the notifications config
NOTIFY_CONFIG = YAML.safe_load(ERB.new(File.read(File.expand_path('../../notifications.yml', __FILE__))).result, [], [], true)
NOTIFY_CONFIG.merge! NOTIFY_CONFIG.fetch(Rails.env, {})
NOTIFY_CONFIG.deep_symbolize_keys!