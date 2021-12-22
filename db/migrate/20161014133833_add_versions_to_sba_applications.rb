class AddVersionsToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :version_number, :integer # sequential version to be displayed in the UI
    add_column :sba_applications, :current_sba_application_id, :integer # the master application this version is associated with
    add_column :sba_applications, :is_current, :boolean # true if this is the current version
  end
end
