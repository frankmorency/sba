#!/bin/bash

echo "RAILS_ENV: $RAILS_ENV"

# Build the crontab
RAILS_ENV=$RAILS_ENV bundle exec  whenever -f config/schedule-ecs.rb -i
touch /etc/crontab /etc/cron.*/*

# Show the crontab
crontab -l
# Start cron process
cron -f
