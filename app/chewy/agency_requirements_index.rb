class AgencyRequirementsIndex < Chewy::Index
  define_type AgencyRequirement.includes(:agency_requirement_organizations, :duty_station, :agency_office, :agency_offer_code) do

    field :title,  value: -> (agency_requirement) {agency_requirement.title}
    field :contract_awarded,  value: -> (agency_requirement) {agency_requirement.contract_awarded}
    field :unique_number, value: -> (agency_requirement) {agency_requirement.unique_number}
    field :naics, value: -> (agency_requirement) {agency_requirement&.agency_naics_code&.code}
    field :duns, value: -> (agency_requirement) {agency_requirement&.agency_requirement_organizations&.map(&:organization)&.flat_map(&:duns_number)}

    field :duty_station, type: 'nested' do
      field :id, index: 'no'
      field :name, value: -> (duty_station) {duty_station.name}
    end

    field :agency_office, type: 'nested' do
      field :id, index: 'no'
      field :name, value: -> (agency_office) {agency_office.name}
    end

    field :agency_offer_code, type: 'nested' do
      field :id, index: 'no'
      field :name, value: -> (agency_offer_code) {agency_offer_code.name}
    end

    field :agency_contract_type, type: 'nested' do
      field :id, index: 'no'
      field :name, value: -> (agency_contract_type) {agency_contract_type.name}
    end

    field :sort_created_at, index: 'not_analyzed', value: -> \
      (agency_requirement) {agency_requirement.created_at&.to_date }

    field :agency_requirement_organizations, type: 'nested' do
      field :id, index: 'no'

      field :organization, type: 'nested' do
        field :id, index: 'no', value: -> (organization) {organization.id}
        field :duns, value: -> (organization) {organization.duns_number}
        field :tax_identifier, value: -> (organization) {organization.tax_identifier}
        field :firm_name, fielddata: 'true', value: -> (organization) { organization.legal_business_name }
      end
    end
  end
end
