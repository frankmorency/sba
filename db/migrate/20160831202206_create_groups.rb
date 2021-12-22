class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t| # Ultimately used to filter the types of applications sba staff can see - the only types of groups discussed so far are regional offices for the 8a program.
      t.references :program, index: true, foreign_key: true # the program this group belongs to
      t.text :name  # the unique label for the group
      t.text :title # the displayable title of the group

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
