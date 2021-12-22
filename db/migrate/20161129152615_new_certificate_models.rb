class NewCertificateModels < ActiveRecord::Migration
  def change
    add_column  :certificate_types, :type, :string                          # sub-class of certificate: WOSB, MPP, etc.
    add_column  :certificate_types, :duration_in_days, :integer             # how long the cert lasts
    add_column  :certificate_types, :wait_period_in_days, :integer          # how long the vendor needs to wait before recertifying
    add_column  :certificate_types, :maximum_allowed, :integer, default: 1  # how many simultaneous certs can you have
    add_column  :certificate_types, :renewal_period_in_days, :integer       # how long the vendor needs to wait to renew

    add_column  :certificates, :type, :string                               # sub-class of certificate: WOSB, MPP, etc.

    
    CertificateType.reset_column_information
    Certificate.reset_column_information

    wosb = CertificateType.get('wosb')
    edwosb = CertificateType.get('edwosb')
    mpp = CertificateType.get('mpp')
    eight_a = CertificateType.get('eight_a')

    wosb.update_attributes type: "CertificateType::Wosb", duration_in_days: 365, wait_period_in_days: 90, maximum_allowed: 1
    edwosb.update_attributes type: "CertificateType::Edwosb", duration_in_days: 365, wait_period_in_days: 90, maximum_allowed: 1
    mpp.update_attributes type: "CertificateType::Mpp", duration_in_days: 365, wait_period_in_days: 90, maximum_allowed: 2
    eight_a.update_attributes type: "CertificateType::EightA", duration_in_days: 8*365, wait_period_in_days: 90, maximum_allowed: 1, renewal_period_in_days: 365

    wosb.certificates.update_all type: "Certificate::Wosb"
    edwosb.certificates.update_all type: "Certificate::Edwosb"
    mpp.certificates.update_all type: "Certificate::Mpp"
    eight_a.certificates.update_all type: "Certificate::EightA"

    # rewrite history cause... postgres can't handle removing and then adding a column in a later migration
    #remove_column :questionnaires, :maximum_allowed
  end
end
