namespace :contributor do
  task expire: :environment do
    @cron_status = CronJobHistory.new
    @cron_status.start_time = Time.new
    @cron_status.type = "contributor:expire"
    @cron_status.save!
    Contributor.expire!
    @cron_status.end_time = Time.new
    @cron_status.save!
  end
end
