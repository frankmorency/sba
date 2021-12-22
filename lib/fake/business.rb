require 'croupier'
require 'faker'

module Fake
  # This is so we can poke the business into the SAM data and make it look like
  # the real thing. We refresh the MvwSamOrganization table after each insertion.
  class SamOrganization < ActiveRecord::Base
    self.table_name = 'sam_organizations'
  end

  class Business
    attr_reader :mailing_address, :physical_address, :city, :zip_code, :state, :name,
                :ein, :duns, :website, :employee_size, :annual_revenue, :business_type

    BUSINESS_TYPES = %w[corp s-corp llc partnership].freeze
    WEB_PROTOCOLS = %w[http http https].freeze
    WEB_PAGE_TYPES = %w[.html .html .html .php .php .cgi /index.html].freeze
    TLDS = %w[.com .com .com .org .net .io .info .biz].freeze

    @@employee_size_generator = Croupier::Distributions.poisson(lambda: 25)
    @@annual_revenue_generator = Croupier::Distributions.poisson(lambda: 5_000)

    def initialize
      @mailing_address = Faker::Address.street_address
      @physical_address = Faker::Address.street_address
      @city = Faker::Address.city
      @zip_code = Faker::Address.zip
      @state = Faker::Address.state_abbr
      @name = Faker::Company.name

      domain = if rand > 0.5
        Faker::Internet.domain_name
      else
        @name.downcase.gsub(/[^a-z0-9]+/, '-') + TLDS.sample
      end

      if rand > 0.8
        @name = @name + " " + Faker::Company.suffix
      end

      @owner = Fake::Person.new
      @duns = Faker::Company.duns_number
      @ein = Faker::Company.ein

      @website = WEB_PROTOCOLS.sample + '://' + domain + '/'
      if rand > 0.6
        @website += Faker::Internet.slug(@name.gsub(/[^A-Za-z0-9]+/, ' ')) + WEB_PAGE_TYPES.sample
      end

      @employee_size = @@employee_size_generator.generate_number
      @annual_revenue = ((1 + @@annual_revenue_generator.generate_number) * Math.sqrt(@employee_size) * 500).round(2)
      @business_type = BUSINESS_TYPES.sample
    end

    def to_sam_org
      {
        dba_name: name,
        legal_business_name: name,
        duns: duns,
        mailing_address_line_1: mailing_address,
        mailing_address_city: city,
        mailing_address_state_or_province: state,
        mailing_address_zip_code_5: zip_code,
        sam_address_1: physical_address,
        sam_city: city,
        sam_province_or_state: state,
        sam_zip_code_5: zip_code,
        govt_bus_poc_first_name: @owner.first_name,
        govt_bus_poc_last_name: @owner.last_name,
        govt_bus_poc_email: @owner.email,
        govt_bus_poc_us_phone: @owner.phone,
        tax_identifier_number: ein,
        tax_identifier_type: '2',
        corporate_url: website,
        state_of_incorporation: state,
        country_of_incorporation: 'USA',
        average_number_of_employees: employee_size,
        average_annual_revenue: annual_revenue,
        sam_extract_code: 'A' # whatever that is -- 'E' is the other option
      }
    end

    def save_to_db!
      ActiveRecord::Base.transaction do
        sam_org = SamOrganization.create!(to_sam_org)
        # now claim the business with the owner
        org = Organization.create!(
          duns_number: duns,
          tax_identifier: ein,
          tax_identifier_type: 'EIN',
          business_type: business_type
        )
        owner_user = @owner.save_to_db!
        # hook up user with org
        Personnel.create!(
          organization: org,
          user: owner_user
        )
        MvwSamOrganization.refresh

        # now we need to add a questionnaire!!

        org
      end
    end

    def to_s
      [ @name,
        @mailing_address,
        "#{@city}, #{@state} #{@zip_code}",
        "",
        "Owner: #{@owner}",
        "Phone: #{@owner.phone}",
        "Web: #{@website}",
        "DUNS: #{@duns}",
        "EIN: #{@ein}",
        "No. Employees: #{employee_size}",
        sprintf("Annual Revenue: $%s", add_commas(sprintf("%.2f", annual_revenue)))
      ].join("\n")
    end

    def add_commas(number)
      whole, part = number.split('.', 2)
      with_commas = whole.reverse.scan(/\d{3}|.+/).join(",").reverse
      if part
        with_commas + '.' + part
      else
        with_commas
      end
    end
  end
end
