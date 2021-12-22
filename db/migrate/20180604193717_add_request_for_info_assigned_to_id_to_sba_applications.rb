class AddRequestForInfoAssignedToIdToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :info_request_assigned_to_id, :integer, index: true, null: true
    set_column_comment :sba_applications, :info_request_assigned_to_id, "The id of the user who's workload queue this application (request for info) will show up in"
  end
end
