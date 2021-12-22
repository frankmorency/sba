task log_to_stdout: :environment do
  Rails.logger = Logger.new(STDOUT) if ENV["RAILS_LOG_TO_STDOUT"].present?
end