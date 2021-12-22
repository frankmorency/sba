class CreateCronJobHistories < ActiveRecord::Migration
  def change
    create_table :cron_job_histories do |t|
      t.string :type
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
