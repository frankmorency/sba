class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.references :loggable, polymorphic: true, comment: 'The associated model'
      t.integer :user_id, comment: 'The user who generated the event, if any'
      t.text :event
      t.text :comment, comment: 'Additional text annotation'
      t.timestamps null: false
    end

    add_index :event_logs, :user_id
    add_index :event_logs, [:loggable_id, :loggable_type]
  end
end
