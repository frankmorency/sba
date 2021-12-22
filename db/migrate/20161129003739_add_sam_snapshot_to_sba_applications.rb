class AddSamSnapshotToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :sam_snapshot, :json
  end
end
