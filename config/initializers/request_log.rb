# Custom logger
require 'singleton'
class RequestLog < Logger
  include Singleton

  def initialize
    if ENV["RAILS_LOG_TO_STDOUT"].present?
      super(STDOUT)
    else
      super('/var/log/rails/request.log')
    end
    self.formatter = formatter()
    self
  end

  # prefixing timestamps automatically
  def formatter
    Proc.new{|severity, time, progname, msg|
      formatted_severity = sprintf("%-5s",severity.to_s)
      formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
      "[#{formatted_severity} #{formatted_time} #{$$}] #{msg.to_s.strip}\n"
    }
  end

  class << self
    delegate :error, :debug, :fatal, :info, :warn, :add, :log, :to => :instance
  end
end
