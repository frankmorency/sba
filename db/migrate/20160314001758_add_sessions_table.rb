class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.text :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, :updated_at

    if %w(dev qa demo_admin stage_admin production_admin).include? Rails.env
      execute <<-SQL
        GRANT DELETE ON TABLE sbaone.sessions TO rl_write;
      SQL
    end
  end
end
