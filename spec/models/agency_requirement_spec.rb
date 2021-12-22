require 'rails_helper'

RSpec.describe AgencyRequirement, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:duty_station) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:agency_office) }
  it { is_expected.to belong_to(:agency_offer_code) }
  it { is_expected.to belong_to(:agency_naics_code) }
  it { is_expected.to belong_to(:agency_offer_scope) }
  it { is_expected.to belong_to(:agency_offer_agreement) }
  it { is_expected.to belong_to(:agency_contract_type) }
  it { is_expected.to belong_to(:agency_co) }

  it { is_expected.to have_many(:agency_requirement_documents) }
  it { is_expected.to have_many(:agency_requirement_organizations) }
  it { is_expected.to have_many(:organizations).through(:agency_requirement_organizations) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:agency_office) }
  it { is_expected.to validate_presence_of(:agency_contract_type) }

  before do
    @agency_requirement = create(:agency_requirement)
  end

  describe "#set_unique_number" do
    it 'should create unique_number attribute' do
      expect(@agency_requirement.unique_number).to be_a(String)
      expect(@agency_requirement.unique_number).to match(/\A[A-Z][A-Z]\d+[A-Z]\z/)
    end
  end

  describe "#write_log" do
    before do
      user = User.first || create(:user)
      @agency_requirement = build(:agency_requirement, user: user, unique_number:"LH1537558ABCD")
    end

    context "create" do
      it "should log a 'created' message" do
        @agency_requirement.save
        event_log = @agency_requirement.event_logs.last
        expect(event_log.event).to eq("created")
      end
    end

    context "update" do
      before do
        @agency_requirement.save
      end
      it "should log a 'updated' message" do
        @agency_requirement.save
        event_log = @agency_requirement.event_logs.last
        expect(event_log.event).to eq("updated")
      end
    end
  end
end

RSpec.describe AgencyContractType, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end

RSpec.describe AgencyOfferCode, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end

RSpec.describe AgencyOfferScope, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end

RSpec.describe AgencyOfferAgreement, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end

RSpec.describe AgencyCo, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
end

RSpec.describe AgencyOffice, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '#display_name' do
    context 'when there is an abbrev' do
      subject { AgencyOffice.new(name: 'Stone Temple Pilots', abbreviation: 'STP').display_name }

      it { should eq('Stone Temple Pilots (STP)') }
    end

    context 'when there is no abbrev' do
      subject { AgencyOffice.new(name: 'Something Else').display_name }

      it { should eq('Something Else') }
    end
  end
end

RSpec.describe AgencyNaicsCode, type: :model do
  it { is_expected.to validate_presence_of(:code) }

  describe '#size' do
    context 'when employees and dollars are set' do
      subject { AgencyNaicsCode.new(size_employees: '1,000', size_dollars_mm: '$0.74').size }

      it { should eq('1,000 Employees') }
    end

    context 'when dollars is set' do
      subject { AgencyNaicsCode.new(size_dollars_mm: '$0.75').size }

      it { should eq('$0.75 M') }
    end

    context 'when neither is set' do
      subject { AgencyNaicsCode.new.size }

      it { should be_nil }
    end
  end
end

RSpec.describe AgencyRequirementOrganization, type: :model do
  it { is_expected.to belong_to(:agency_requirement) }
  it { is_expected.to belong_to(:organization) }

  before do
    @organization = create(:organization)
    @agency_requirement = create(:agency_requirement)
    @agency_requirement_organization = AgencyRequirementOrganization.new(organization: @organization, agency_requirement: @agency_requirement)
  end

  describe "when organization already exists for agency_requirement" do
    before do
      duplicate_record = @agency_requirement_organization.dup
      duplicate_record.save
    end

    it "should raise db error when validation is skipped" do
      expect{@agency_requirement_organization.save!(validate: false)}.to raise_error
    end
  end
end
