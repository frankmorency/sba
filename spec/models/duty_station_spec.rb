require 'rails_helper'

RSpec.describe DutyStation, type: :model do
  it { is_expected.to have_many(:offices) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:office_requests) }
  it { is_expected.to have_many(:access_requests) }
  it { is_expected.to have_many(:certificates) }
  it { is_expected.to have_and_belong_to_many(:sba_applications) }

  describe "#stations_with_district_office_sba_users" do
    before do
      @user = create(:user_random)
      @user.add_role :sba_supervisor_8a_district_office
      @dt_sf = DutyStation.find_by(name: 'San Francisco')
      @user.duty_stations << @dt_sf
      @filtered_station = DutyStation.stations_with_district_office_sba_users.first
    end

    it 'should return the expected duty station' do
      expect(@dt_sf).to eq(@filtered_station)
    end

    it 'should return duty station with user with correct role' do
      expect(@filtered_station.users.first.has_role?(:sba_supervisor_8a_district_office) ).to eq(true)
    end

    it 'should return user associated to correct duty station' do
      expect(@filtered_station.users.first.id).to eq(@user.id)
    end

  end

  describe "#short_name" do
    before do
      @dt_sf = DutyStation.find_by(name: 'San Francisco')
    end

    it 'should return parameterized duty station name' do
      expect(@dt_sf.short_name).to eq('San Francisco'.parameterize)
    end
  end
end
