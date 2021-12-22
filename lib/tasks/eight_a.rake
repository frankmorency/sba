require 'csv'

namespace :eight_a do
  desc "Create annual reviews for 8(a) certificates Daily for firms 30 days prior to their anniversary date. "
  task create_annual_reviews_daily: :environment do
    cron = CronJobHistory.new
    cron.type = "eight_a:create_annual_reviews_daily"
    cron.start!
    Certificate::EightA.create_annual_reviews!
    cron.stop!
  end

  desc "Create annual reviews for 8(a) certificates due for past 30 days on launch date."
  task create_annual_reviews_due_at_launch: :environment do
    exclude_file = 'db/fixtures/eight_a/annual_review/initial_launch/exclude_duns.csv'
    exclude_duns = []
    CSV.foreach(exclude_file, headers: true, header_converters: :symbol) do |row|
      exclude_duns << row[:duns]
    end
    cron = CronJobHistory.new
    cron.type = "eight_a:create_annual_reviews_due_at_launch"
    cron.start!
    (-90..30).each do |days_ahead|
      Certificate::EightA.create_annual_reviews!(days_ahead.days, exclude_duns)
    end
    cron.stop!
  end

  desc "Send Annual Review reminders on Anniversary date"
  task send_reminder_on_anniversary_date: :environment do
    cron = CronJobHistory.new
    cron.type = "eight_a:send_reminder_on_anniversary_date"
    cron.start!
    SbaApplication::EightAAnnualReview.send_reminder_email_on_anniversary(Date.today)
    cron.stop!
  end

  desc "Clears declined SBA applications that have not requested reconsiderations or appeals on time"
  task clear_denied_statuses: :environment do
    cron = CronJobHistory.new
    cron.type = "eight_a:clear_denied_statuses"
    cron.start!
    Review::EightA.clear_denied_statuses!
    cron.stop!
  end

end
