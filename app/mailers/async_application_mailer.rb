class AsyncApplicationMailer < ApplicationMailer
  include Resque::Mailer
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff
  @queue = :mailer

  # All Notifiers inherited from this class
  # require same resque-retry options.
  # Resque workers are classes but not instances of classes.
  # That is why resque retry require class variables that is not inherited
  # In order to setup same resque-retry class variables
  # for every inherited class we need this hack.
  def self.inherited(host)
    super(host)
    host.class_eval do
      @retry_exceptions = [Net::SMTPServerBusy, Timeout::Error, Resque::DirtyExit]
      @retry_limit = 3
      @retry_delay = 60 #seconds
      @backoff_strategy = [0, 60, 600]
      @retry_delay_multiplicand_min = 1.0
      @retry_delay_multiplicand_max = 1.0
    end
  end
end
