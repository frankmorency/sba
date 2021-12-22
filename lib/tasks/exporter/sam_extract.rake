namespace :exporter do
  desc 'Executes an sam extract query for GCBD and uploads results to Minerva'
  task :sam_extract, [:csv] => :environment do |t, args|
    cron = CronJobHistory.new
    cron.type = 'exporter:sam_extract'
    cron.start!

    if args[:csv].nil?
      csv = Rails.env.production? ? 'sam_extract.csv' : 'sam_extract_test.csv'
    else
      csv = args[:csv]
    end

    host = ENV['MINERVA_SERVER']
    name = ENV['MINERVA_EXPORTER_GCBD_USER']
    pwd = ENV['MINERVA_EXPORTER_GCBD_PW']

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      rake_logger = ActiveSupport::Logger.new(STDOUT)
    else
      rake_logger = ActiveSupport::Logger.new("/var/log/rails/export_agent.log")
    end
    rake_logger.info("#{Time.now} Executing rake task exporter:SamExtract.")

    begin
      exporter = Exporter::SamExtract.new
      exporter.run(host: host, name: name, pw: pwd, filename: csv)
    ensure
      rake_logger.info("#{Time.now} Completed rake task exporter:SamExtract.\n")
    end

    cron.stop!
  end
end
