class UpdateMppCertificationExpiration < ActiveRecord::Migration
  def change
    
    duration = 365 * 3
    type = CertificateType.find_by(name: 'mpp')
    type.update_attribute :duration_in_days, duration
    type.certificates.where('workflow_state = ? AND issue_date IS NOT NULL', 'active').each do |cert|
      cert.update_attribute(:expiry_date, cert.issue_date + duration.days)
    end
  end
end
