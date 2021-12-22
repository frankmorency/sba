class CreateVoluntarySuspensions < ActiveRecord::Migration
  def change
    create_table :voluntary_suspensions do |t|
      t.string :option
      t.string :title
      t.text :body
      t.integer :status, default: 0
      t.string :document
      t.timestamps null: false
    end
  end
end
