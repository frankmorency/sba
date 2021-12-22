class AddAdditionalIndexesToSections < ActiveRecord::Migration
  def change
    add_index :sections, :sba_application_id, name: :index_sections_on_sba_application_id
  end
end
