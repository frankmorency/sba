class SeedAgencyData < ActiveRecord::Migration
  def change
    ["Offer Incomplete", "Offer not suitable for 8(a) Program", "Adverse Impact", "Solicitation Previously Issued", "Offer Canceled or Withdrawn", "Offer exceeds threshold amounts", "Offer Accepted", "Void Duplicate"].each do |code|
      AgencyOfferCode.create! name: code
    end

    AgencyOfferAgreement.create! name: 'Not Applicable'
    AgencyOfferAgreement.create! name: 'Joint Venture'
    AgencyOfferAgreement.create! name: 'Management'
    AgencyOfferAgreement.create! name: 'Mentor Protégé'
    AgencyOfferScope.create! name: 'Local Buy'
    AgencyOfferScope.create! name: 'Regional Buy'
    AgencyOfferScope.create! name: 'National Buy'

    AgencyContractType.create! name: 'Sole-Source'
    AgencyContractType.create! name: 'Competitive'

    JSON.load(Rails.root.join('db', 'migrate', 'agencies.json')).each do |agency|
      AgencyOffice.create!(name: agency['name'], abbreviation: agency['short_name'])
    end

    CSV.foreach(Rails.root.join('db', 'migrate', 'agency_naics_codes.csv'), headers: true) do |row|
      AgencyNaicsCode.create! code: row['code'],industry_title: row['industry_title'], size_dollars_mm: row['size_dollars_mm'], size_employees: row['size_employees']
    end
  end
end
