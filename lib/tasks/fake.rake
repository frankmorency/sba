namespace :fake do
  desc "Create a new business"
  task :business, [:count] => :environment do |t, args|
    Faker::Config.locale = 'en-US'

    count = (args[:count] || 1).to_i
    businesses = (1..count).map { Fake::Business.new }

    # create SAM organization
    # create organization
    businesses.each do |business|
      org = business.save_to_db!
      puts "Created #{org.legal_business_name}"
      Fake::Questionnaire.new(organization: org, fake_business: business).save_to_db!
    end

    puts businesses.join("\n\n---------\n\n")
  end
end
