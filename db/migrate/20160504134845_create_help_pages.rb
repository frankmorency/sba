class CreateHelpPages < ActiveRecord::Migration
  def change
    create_table :help_pages do |t|

      t.text :title
      t.text :left_panel
      t.text :right_panel

      t.timestamps null: false
    end
  end
end
