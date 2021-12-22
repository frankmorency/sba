class AddReturnInfoToApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :returned_reviewer_id, :integer
  end
end
