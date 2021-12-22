class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :name
      t.string :display_name

      t.timestamps null: false
    end
  end
end
