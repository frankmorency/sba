class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t| # This table represents SBA Programs, such as WOSB, 8A and HubZone
      t.text :name # unique label for the program
      t.text :title # displayable program name

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
