require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:personnels) }
  it { is_expected.to have_many(:documents) }
  it { is_expected.to have_many(:sba_applications) }
  it { is_expected.to have_many(:access_requests) }
  it { is_expected.to have_many(:agency_requirement_organizations) }
  it { is_expected.to have_many(:agency_requirements).through(:agency_requirement_organizations) }

  describe "validations" do
    subject {create(:organization)}
    it {should validate_uniqueness_of(:duns_number)}
  end

  describe "Personnels" do
    before do
      @organization = create(:organization)
    end

    it 'should not be in any organization' do
      expect(@organization.users.empty?).to eq(true)
      expect(@organization.personnels.empty?).to eq(true)
    end

    it 'should assign a user via << user' do
      user = vendor_user
      @organization.users << user
      expect(@organization.reload.users.empty?).to eq(false)
    end
  end

  describe 'Personnels should be assigned and removed from organization' do
    before do
      user = vendor_user
      @organization = create(:organization)
      @organization.users << user
    end

    it 'Should be assigned and deleted to an organization' do
      user = vendor_user
      Personnel.create!(user_id: user.id, organization_id: @organization.id)
      expect(@organization.reload.users.count).to eq(2)
      user = @organization.users.first.delete
      expect(@organization.reload.users.count).to eq(1)
      expect(@organization.reload.users.with_deleted.count).to eq(2)
    end
  end
end
