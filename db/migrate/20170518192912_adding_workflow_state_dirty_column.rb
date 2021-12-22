class AddingWorkflowStateDirtyColumn < ActiveRecord::Migration
  def change

    add_column :sba_applications, :workflow_dirty, :boolean, default: false
    add_column :certificates, :workflow_dirty, :boolean, default: false
    add_column :reviews, :workflow_dirty, :boolean, default: false

  end
end
