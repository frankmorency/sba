class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text :name, null: false
      t.text :iso_alpha2_code, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
