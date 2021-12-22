class CreateAnnualReports < ActiveRecord::Migration
  def change
    create_table :annual_reports do |t|
      t.references :certificate
      t.references :sba_application
      t.string :status
      t.integer :reviewer_id

      t.timestamps null: false
    end

    add_column  :certificates, :next_annual_report_date, :date
    add_column  :certificate_types, :annual_report_period_in_days, :integer

    CertificateType.reset_column_information
    SbaApplication.reset_column_information

    
    CertificateType::Mpp.update_all annual_report_period_in_days: 365

    Certificate.where(type: "Certificate::Mpp", workflow_state: 'active').all.each do |cert|
      date = cert.issue_date || cert.created_at.to_date
      cert.update_attribute(:next_annual_report_date, date + 365.days)
    end
  end
end
