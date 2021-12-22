def create_database_schema(environment = Rails.env.to_sym)
  ActiveRecord::Base.establish_connection(environment).connection.execute "CREATE SCHEMA sbaone;"
  ActiveRecord::Base.establish_connection(environment).connection.execute "CREATE SCHEMA audit;"
  ActiveRecord::Base.establish_connection(environment).connection.execute "CREATE SCHEMA reference;"
rescue ActiveRecord::StatementInvalid => e
  Rails.logger.error "There was a problem creating schema: #{e}"
end

def create_parallel_db(environment = Rails.env.to_sym)
  config = Rails.configuration.database_configuration
  database = config[Rails.env]["database"] + "abc"
  owner = config[Rails.env]["username"]
  (1..4).each do |n|
    new_db = database + n.to_s
    cmd = "CREATE DATABASE #{new_db} WITH TEMPLATE #{database} OWNER #{owner};"
    ActiveRecord::Base.establish_connection(environment).connection.execute cmd
  end
rescue ActiveRecord::StatementInvalid => e
  Rails.logger.error "There was a problem creating DB: #{e}"
end

namespace :db do
  desc "Start over - only run on lower lanes"
  task start_over: :environment do
     unless Rails.env.development?
       fail "This task is not allowed in this or higher environments"
     end
     Rake::Task["db:drop"].invoke
     Rake::Task["db:create"].invoke
     Rake::Task["db:migrate"].invoke
  end

  desc "Drop all tables"
  task clear: :environment do
    unless Rails.env.qa? || Rails.env.build_admin? || Rails.env.development? || Rails.env.test? || Rails.env.docker? || Rails.env.dev? || Rails.env.demo? || Rails.env.training? || Rails.env.training_admin?
      fail "This task is not allowed in this or higher environments"
    end
    conn = ActiveRecord::Base.connection
    tables = conn.execute("SELECT * FROM pg_catalog.pg_tables where schemaname='sbaone'").map { |r| r['tablename'] }
    tables.each { |t| conn.execute("DROP TABLE IF EXISTS #{t} CASCADE") }
    conn.execute("DROP TABLE IF EXISTS audit.versions CASCADE")
    if Rails.env.dev? || Rails.env.dev_admin? || Rails.env.qa? || Rails.env.demo? || Rails.env.training? || Rails.env.training_admin? || Rails.env.docker?
      conn.execute("DROP TABLE IF EXISTS reference.sam_organizations CASCADE")
    end
  end

  Rake::Task["db:create"].enhance do
    Rake::Task["db:create_schema"].invoke
    create_database_schema(:test) if Rails.env.development?
  end

  desc "Create schema 'sbaone' (auto invoked after rake db:create)"
  task create_schema: :environment do
    create_database_schema
  end

  desc "Create Parallel DB's for test"
  task parallel_create: :environment do
    create_parallel_db
  end
end
