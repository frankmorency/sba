# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, ENV['RAILS_ENV']

every 2.minutes do
  rake "av:scan_files"
end

every 30.minutes do
  rake "compress:set_ready"
end

# Compress once an hour for now.
every 60.minutes do
  rake "compress:pdfs"
end

every 60.minutes do
  rake "eight_a:create_annual_reviews_daily"
end

every 1.day, :at => '6:00 am' do
  rake "eight_a:send_reminder_on_anniversary_date"
end

every 1.day, :at => '6:30 am' do
  rake "certificate:wosb_expiry_email_reminder"
  #rake "certificate:mpp_expiry_email_reminder"
end

# ES Index updates are not happeing from the rake task. Call
every 1.day, :at => '12:05 am' do
  rake "certificate:expire"
end

# Check if Case has expired
# every 1.day, :at => '12:15 am' do
#   rake "review:appeal_expired"
# end

# Remove Denied 8(a) Initial applications from SBA workload queues after 55 days
# every 1.day, :at => '12:30 am' do
#   rake "eight_a:clear_denied_statuses"
# end

# Reset Chewy Index every day after the nightly certificate expire job to get the index updated
every 1.day, :at => '1:00 am' do
  rake "chewy:reset[cases]" # Does zero downtime update of the index - https://github.com/toptal/chewy#rake-tasks
end

every 1.day, :at => '2:10 am' do
  rake "contributor:expire"
end

every 1.day, :at => '2:30 pm' do
  rake "support:daily_application_report['/tmp/daily_application_report.txt']"
end

every 1.day, :at => '11:00 pm' do
  if environment == 'production'
    puts "Configuring dsbs for production"
    rake "exporter:dsbs[certify_certificates.csv]"
  else
    puts "Skipping dsbs configuration"
  end
end
