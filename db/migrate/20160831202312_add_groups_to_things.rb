class AddGroupsToThings < ActiveRecord::Migration
  def change
    add_column  :questionnaires, :program_id, :integer

    add_index :questionnaires, :program_id, name: :index_qs_on_program_id
    add_foreign_key :questionnaires, :programs
  end
end
