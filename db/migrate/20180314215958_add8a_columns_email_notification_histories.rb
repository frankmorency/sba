class Add8aColumnsEmailNotificationHistories < ActiveRecord::Migration
  def change
    change_table(:email_notification_histories) do |t|
      t.string :error, default: nil # Error message if there is an exception while creating or sending an 8(a) Annual Review Application / Notification
      t.integer :annual_review_sba_application_id, default: nil # 8(a) Annual Review Application for successfully created applications
    end
  end
end
