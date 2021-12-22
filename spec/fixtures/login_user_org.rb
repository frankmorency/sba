module Spec
  module Fixtures
    class UserOrg
      def self.load
        CertificateType::Wosb.create! name: 'wosb', title: 'WOSB', duration_in_days: 365
        CertificateType::Edwosb.create! name: 'edwosb', title: 'EDWOSB', duration_in_days: 365

        (2).times do |i|
          user = User.new(first_name: "Applicant#{i}", last_name: "Last Name", email: "applicant#{i}@email.com", password: 'Say Spoken Journey Greatly', password_confirmation: 'Say Spoken Journey Greatly')
          user.organizations.new(duns_number: "DUNS123456_#{i}", tax_identifier: "EIN123456_#{i}", tax_identifier_type: 'EIN', legal_business_name: "Company #{i} Inc",
                                 sam_address_line1: 'Address Line 1', sam_address_line2: 'Address Line 2', sam_city: 'Herndon', sam_zipcode5: 20171, sam_zipcode4: 1234)
          user.save!
        end

      end
    end
  end
end