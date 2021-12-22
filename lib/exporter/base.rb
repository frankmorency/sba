require 'csv'

module Exporter
  class Base
    attr_reader :results, :e_logger, :csv_file, :tempfile_manager

    def initialize
      if (ENV["RAILS_LOG_TO_STDOUT"].present? || Rails.env.test?)
        @e_logger = ActiveSupport::Logger.new(STDOUT)
      else
        @e_logger = ActiveSupport::Logger.new("/var/log/rails/export_agent.log")
      end
      @tempfile_manager = TempfileManager.new

      @results = []
    end

    def run(host:, name:, pw:, filename:, emails: nil )
      if execute_query
        begin
          tempfile_manager.create_and_open(filename)
          write_results_to_file(filename)
          email_report(emails, tempfile_manager[filename]) if !emails.nil?
          tempfile_manager[filename].close

          # Comment out the line below for local dev/testing because it calls SFTP. 
          # The credentials for the Minerva server are not available for local test/dev
          # BE SURE to uncomment the line before merging
          # TODO: see if the unless fixes the testing by not running SFTP during testing
          # if so, change the comment above but document the edge case here
          export_file(host, name, pw, filename) unless Rails.env.test?

          e_logger.info("#{Time.now} SUCCESS #{self.class.name}: Exported #{filename} to Minerva.")
        rescue => e
          e_logger.error("#{Time.now}, FAILURE (run) #{e.message}")
          raise e
        ensure
          tempfile_manager.close_and_unlink(filename)
        end
      end
    end

    def execute_query
      begin
        @results = ActiveRecord::Base.connection.execute(query)

        e_logger.info("#{Time.now} SUCCESS #{self.class.name}: Query returned #{results.count} records.")
        true
      rescue PG::Error, ActiveRecord::StatementInvalid => e
        e_logger.error("#{Time.now}, FAILURE (execute_query) #{e.message}")
        false
      end
    end

    protected

    def export_file(host, name, pw, file_name)
      Net::SFTP.start(host, name, password: pw) do |sftp|
        sftp.upload!(tempfile_manager.path(file_name), file_name)
      end
    end

    def email_report(emails, file_name)
      DsbsReportMailer.send_email(emails, file_name).deliver_now
        e_logger.info("#{Time.now} SUCCESS #{self.class.name}: Emailed #{file_name} to #{emails}.")
        true
      rescue => e
        e_logger.error("#{Time.now}, FAILURE (email_report) #{e.message}")
        false
    end

    def write_results_to_file(file_name)
      CSV.open(tempfile_manager[file_name], 'w', force_quotes: true) do |csv|
        csv << headers
        results.each { |row| csv << row_converter(row)&.values }
      end
    end

    def row_converter(row)
      raise NotImplementedError, 'Exporter::Base is abstract, subclasses must define "row_converter".'
    end

    def query
      raise NotImplementedError, 'Exporter::Base is abstract, subclasses must define "query".'
    end

    def headers
      raise NotImplementedError, 'Exporter::Base is abstract, subclasses must define "headers".'
    end
  end
end
