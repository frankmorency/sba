namespace :access_request do
  desc "Populate a basic set of access requests"
  task seed: :environment do
    AccessRequest.create! requestor: User.find_by(first_name: "CO1"),
                          request_expires_on: 2.days.from_now,
                          access_expires_on: 3.months.from_now,
                          status: "requested",
                          solicitation_number: 'ASDAF-1231-DFSFG',
                          solicitation_naics: '212333',
                          organization: Organization.find_by(business_type: 'llc')
    AccessRequest.create! requestor: User.find_by(first_name: "CO2"),
                          request_expires_on: 1.days.from_now,
                          access_expires_on: 3.months.from_now,
                          status: "requested",
                          solicitation_number: 'D3FDJK-1231-DFSFG',
                          solicitation_naics: '535333',
                          organization: Organization.find_by(business_type: 'llc')
    AccessRequest.create! requestor: User.find_by(first_name: "CO2"),
                          request_expires_on: 5.days.from_now,
                          access_expires_on: 1.months.from_now,
                          status: "requested",
                          solicitation_number: 'D3FDJK-1231-ASFFF',
                          solicitation_naics: '555444',
                          organization: Organization.find_by(business_type: 's-corp')

    AccessRequest.create! requestor: User.find_by(first_name: "CO3"),
                          request_expires_on: 10.days.from_now,
                          access_expires_on: 2.months.from_now,
                          status: "requested",
                          solicitation_number: 'VADFAF-1231-DFSFG',
                          solicitation_naics: '666555',
                          organization: Organization.find_by(business_type: 'corp')

    AccessRequest.create! requestor: User.find_by(first_name: "CO1"),
                          request_expires_on: 3.days.from_now,
                          access_expires_on: 6.months.from_now,
                          status: "requested",
                          solicitation_number: 'ASFAFG-1231-DFSFG',
                          solicitation_naics: '123232',
                          organization: Organization.find_by(business_type: 'partnership')


  end
end
