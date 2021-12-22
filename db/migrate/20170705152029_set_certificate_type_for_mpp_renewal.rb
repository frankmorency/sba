class SetCertificateTypeForMppRenewal < ActiveRecord::Migration
  def change
    
    Questionnaire.find_by(name: 'mpp_annual_renewal').update_attribute :certificate_type_id, CertificateType.find_by(name: 'mpp').id
  end
end
