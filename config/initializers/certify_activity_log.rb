# For development set environment variable ACTIVITY_LOG_API_URL="http://localhost:3005"
CertifyActivityLog.configure do |config|
  template = ERB.new File.new("#{Rails.root.to_s}/config/activity_log.yml").read
  processed = YAML.load template.result(binding)
  configuration = processed[Rails.env]
  config.api_url = configuration["api_url"]
  config.excon_timeout = 5
end