class CreateBusinessUnits < ActiveRecord::Migration
  def change
    
    create_table :business_units do |t|
      t.string :name
      t.timestamps null: false
    end

    add_column :duty_stations, :name, :string
  end
end
