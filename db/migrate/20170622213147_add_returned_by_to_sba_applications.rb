class AddReturnedByToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :returned_by, :integer # track the last case owner who returned this application to vendor
  end
end
