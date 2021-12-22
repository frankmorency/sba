class CreateBdmisMigrations < ActiveRecord::Migration
  def change
    create_table :bdmis_migrations do |t|
      t.references :sba_application, index: true, foreign_key: true
      t.text :error_messages
      t.date :approval_date
      t.text :case_number
      t.text :case_url
      t.text :certification
      t.text :company_name
      t.date :decline_date
      t.text :ein
      t.date :next_review
      t.integer :office
      t.integer :page
      t.text :status
      t.datetime :submitted_on_date
      t.date :exit_date
      t.date :approved_date
      t.integer :office_code
      t.text :office_name
      t.integer :district_code
      t.text :district_name
      t.text :duns
      t.text :hashed_duns
      t.timestamps null: false
    end
  end
end
