class RemoveInvalidCertTypes < ActiveRecord::Migration
  def change
    
    CertificateType.find_by(name: 'eight_a_disadvantaged_individual').destroy
    CertificateType.find_by(name: 'eight_a_business_partner').destroy
    CertificateType.find_by(name: 'eight_a_spouse').destroy
  end
end
