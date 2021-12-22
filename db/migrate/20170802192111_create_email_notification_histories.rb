class CreateEmailNotificationHistories < ActiveRecord::Migration
  def change
    create_table :email_notification_histories do |t|
      t.string :program
      t.integer :days
      t.integer :organization_id
      t.string :email
      t.timestamps null: false
    end
  end
end
