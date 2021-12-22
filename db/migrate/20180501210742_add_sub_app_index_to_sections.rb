class AddSubAppIndexToSections < ActiveRecord::Migration
  def change
    add_index :sections, :sub_application_id, name: :index_sections_on_sub_application_id
  end
end
