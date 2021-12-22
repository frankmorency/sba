# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'resque-retry'
require 'resque/failure/redis'
require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'ci/reporter/rake/rspec'
require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

task rspec: 'ci:setup:rspec'

Cucumber::Rake::Task.new(:features) do |t|
  t.fork = true
  t.cucumber_opts = ['--format',(ENV['CUCUMBER_FORMAT'] || 'pretty')]
  t.cucumber_opts = ['--tags',(ENV['CUCUMBER_TAGS'] || '~none')]
  t.profile = 'default'
end

task :default => :features
