class AddWorkflowStateToCertificationAndSbaApplications < ActiveRecord::Migration
  def change
    change_column_null :sba_applications, :application_status_type_id, true   # this deprecated column is deprecated and is no longer required
    change_column_null :certificates, :certificate_status_type_id, true       # this deprecated column is deprecated and is no longer required
    add_column :sba_applications, :renewal, :boolean, default: false          # some applications may be renewals of initial applications (in the future)
    add_column :sba_applications, :workflow_state, :text                      # workflow gem uses this field to store the current state of an sba application
    add_column :certificates, :workflow_state, :text                          # workflow gem uses this field to store the current state of a certificate
  end
end
