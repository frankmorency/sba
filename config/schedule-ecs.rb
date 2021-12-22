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

set :output, '/proc/1/fd/1'
env :PATH, ENV['path']
set :environment, ENV['RAILS_ENV']
set :job_template, nil
ENV.each { |k,v| env(k, v) }
#set :environment, ENV['RAILS_ENV']
#set :output, STDOUT

every 2.minutes do
  command 'cd /app && rake av:scan_files 2>/proc/1/fd/2'
end



every 30.minutes do
  command "cd /app && rake compress:set_ready 2>/proc/1/fd/2"
end

# Compress once an hour for now.
every 60.minutes do
  command "cd /app && rake compress:pdfs  2>/proc/1/fd/2"
end

every 1.day, :at => '10:05 am' do
  command  "cd /app && rake eight_a:create_annual_reviews_daily 2>/proc/1/fd/2"
end

every 1.day, :at => '11:05 am' do
  command "cd /app && rake vs:activate 2>/proc/1/fd/2"
end

every 1.day, :at => '11:10 am' do
  command "cd /app && rake eight_a:send_reminder_on_anniversary_date 2>/proc/1/fd/2"
end

# every 1.day, :at => '6:30 am' do
#   command "cd /app && rake certificate:wosb_expiry_email_reminder 2>/proc/1/fd/2"
# end

# ES Index updates are not happeing from the rake task. Call
every 1.day, :at => '12:05 am' do
  command "rake certificate:expire 2>/proc/1/fd/2"
end

# Check if Case has expired
every 1.day, :at => '12:00 am' do
  command "rake eight_a:appeal_expired 2>/proc/1/fd/2"
end

# Remove Denied 8(a) Initial applications from SBA workload queues after 55 days
every 1.day, :at => '12:30 am' do
  command "cd /app && rake eight_a:clear_denied_statuses 2>/proc/1/fd/2"
end

# Reset Chewy Index every day after the nightly certificate expire job to get the index updated
every 1.day, :at => '1:00 am' do
  command "cd /app && rake chewy:reset[cases] 2>/proc/1/fd/2" # Does zero downtime update of the index - https://github.com/toptal/chewy#rake-tasks
end

every 1.day, :at => '2:10 am' do
  command "cd /app && rake contributor:expire 2>/proc/1/fd/2"
end

every 1.day, :at => '2:30 pm' do
  command "cd /app && rake support:daily_application_report['/tmp/daily_application_report.txt'] 2>/proc/1/fd/2"
end

every 1.day, :at => '11:00 pm' do
  if environment == 'production'
    puts "Configuring dsbs for production"
    command "cd /app && rake exporter:dsbs[certify_certificates.csv] 2>/proc/1/fd/2"
  else
    puts "Skipping dsbs configuration"
  end
end
