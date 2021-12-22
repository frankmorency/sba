require 'rails_helper'

describe DataUpdates::EightAExpiry do
  describe "#update" do
    before do
      @normal_cert = Certificate::EightA.new(issue_date: Date.today, expiry_date: Date.tomorrow)
      allow(@normal_cert).to receive(:from_bdmis?).and_return false

      @bdmis_cert = Certificate::EightA.new(issue_date: Date.today, expiry_date: Date.tomorrow)
      allow(@bdmis_cert).to receive(:from_bdmis?).and_return true

      @certificates = [
          @normal_cert,
          @bdmis_cert
      ]

      @data_updater = DataUpdates::EightAExpiry.new(false)
    end

    it 'should update the expiry_date to 9 years from the issue date (for records with an issue and expiry date' do
      expect(@data_updater.certificate_type.certificates).to receive(:where).with('issue_date IS NOT NULL AND expiry_date IS NOT NULL').and_return @certificates
      @data_updater.update!

      expect(@normal_cert.expiry_date).to eq(3286.days.from_now.to_date)
      expect(@bdmis_cert.expiry_date).to eq(Date.tomorrow)
    end
  end
end
