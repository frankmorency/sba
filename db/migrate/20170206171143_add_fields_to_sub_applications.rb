class AddFieldsToSubApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :master_application_id, :integer, index: true
    add_column :sba_applications, :position, :integer
  end
end
