class MigrateWorkflowState < ActiveRecord::Migration
  def change
    SbaApplication.reset_column_information
    Certificate.reset_column_information

    
    ApplicationStatusType.find_by(name: 'Draft').sba_applications.each do |app|
      app.update_attribute(:workflow_state, 'draft')
      app.update_attribute(:application_status_type_id, nil)
    end

    ApplicationStatusType.find_by(name: 'Submitted').sba_applications.each do |app|
      app.update_attribute(:workflow_state, 'submitted')
      app.update_attribute(:application_status_type_id, nil)
    end

    ApplicationStatusType.find_by(name: 'Inactive').sba_applications.each do |app|
      app.update_attribute(:workflow_state, 'inactive')
      app.update_attribute(:application_status_type_id, nil)
    end

    CertificateStatusType.find_by(name: 'Inactive').certificates.each do |cert|
      cert.update_attribute(:workflow_state, 'inactive')
      cert.update_attribute(:certificate_status_type_id, nil)
    end

    CertificateStatusType.find_by(name: 'Active').certificates.each do |cert|
      cert.update_attribute(:workflow_state, 'active')
      cert.update_attribute(:certificate_status_type_id, nil)
    end

    CertificateStatusType.find_by(name: 'Archived').certificates.each do |cert|
      cert.update_attribute(:workflow_state, 'archived')
      cert.update_attribute(:certificate_status_type_id, nil)
    end
  end
end
