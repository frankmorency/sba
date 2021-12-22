require 'rails_helper'

RSpec.describe Certificate::EightA, type: :model do
  before do
    @org = create(:org_with_user)
    @cert_type = CertificateType::EightA.first
    @cert = create(:certificate_eight_a_initial, workflow_state: 'active', organization_id: @org.id, certificate_type: @cert_type)
  end

  describe "finalized?" do

    context "certificate is terminated" do
      before do
        @cert.update_attribute(:issue_date, (1.years.ago + 30.days).to_date)
        @cert.update_attribute(:expiry_date, @cert.issue_date + @cert_type.duration_in_days.days)
        @cert.update_attribute(:workflow_state, "terminated")
      end

      it 'should return true' do
        expect(@cert.finalized?).to be_truthy
      end

      it 'should not send an email' do
        Certificate::EightA.create_annual_reviews!
        @email_count = EmailNotificationHistory.count
        expect(@email_count).to eq 0
      end
    end

    context "certificate is early_graduated" do
      before do
        @cert.update_attribute(:issue_date, (1.years.ago + 30.days).to_date)
        @cert.update_attribute(:expiry_date, @cert.issue_date + @cert_type.duration_in_days.days)
        @cert.update_attribute(:workflow_state, "early_graduated")
      end

      it 'should return true' do
        expect(@cert.finalized?).to be_truthy
      end

      it 'should not send an email' do
        Certificate::EightA.create_annual_reviews!
        @email_count = EmailNotificationHistory.count
        expect(@email_count).to eq 0
      end
    end

    context "certificate is voluntary_withdrawn" do
      before do
        @cert.update_attribute(:issue_date, (1.years.ago + 30.days).to_date)
        @cert.update_attribute(:expiry_date, @cert.issue_date + @cert_type.duration_in_days.days)
        @cert.update_attribute(:workflow_state, "voluntary_withdrawn")
      end

      it 'should return true' do
        expect(@cert.finalized?).to be_truthy
      end

      it 'should not send an email' do
        Certificate::EightA.create_annual_reviews!
        @email_count = EmailNotificationHistory.count
        expect(@email_count).to eq 0
      end
    end

    context "certificate is active" do
      before do
        @cert.update_attribute(:issue_date, (1.years.ago + 30.days).to_date)
        @cert.update_attribute(:expiry_date, @cert.issue_date + @cert_type.duration_in_days.days)
        @cert.update_attribute(:workflow_state, "active")
      end

      it 'should return true' do
        expect(@cert.finalized?).to be_falsey
      end

      xit 'should not send an email' do
        Certificate::EightA.create_annual_reviews!
        @email_count = EmailNotificationHistory.count
        expect(@email_count).to eq 1
      end
    end

  end

  describe "covid?" do
    context "certificate issued at start of COVID period" do
      before do
        @cert.update_attribute(:issue_date, "2011-3-13".to_date)
      end

      it 'should return true' do
        expect(@cert.covid_issue_date?).to be_truthy
      end
    end

    context "certificate issued at end of COVID period" do
      before do
        @cert.update_attribute(:issue_date, "2020-9-9".to_date)
      end

      it 'should return true' do
        expect(@cert.covid_issue_date?).to be_truthy
      end
    end

    context "certificate issued before of COVID period" do
      before do
        @cert.update_attribute(:issue_date, "2011-3-12".to_date)
      end

      it 'should return false' do
        expect(@cert.covid_issue_date?).to be_falsey
      end
    end

    context "certificate issued after COVID period" do
      before do
        @cert.update_attribute(:issue_date, "2020-9-10".to_date)
      end

      it 'should return false' do
        expect(@cert.covid_issue_date?).to be_falsey
      end
    end
  end

end
