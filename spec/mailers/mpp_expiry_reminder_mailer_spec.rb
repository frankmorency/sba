require "rails_helper"

RSpec.describe MppExpiryReminderMailer, type: :mailer do
  before do
    @mailer_certificate = build(:certificate_eight_a)
    allow(@mailer_certificate).to receive(:next_annual_report_date).and_return(Date.today)

    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  describe "when attempting to send emails" do
    context "with all parameters set" do
      it 'the 60 day reminder email should not be sent' do
        MppExpiryReminderMailer.send_60_day_reminder(@mailer_certificate, 'john@mailinator.com').deliver
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'the 45 day reminder email should not be sent' do
        MppExpiryReminderMailer.send_45_day_reminder(@mailer_certificate, 'john@mailinator.com').deliver
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'the 30 day reminder email should not be sent' do
        MppExpiryReminderMailer.send_30_day_reminder(@mailer_certificate, 'john@mailinator.com').deliver
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'the 1 day past due email should not be sent' do
        MppExpiryReminderMailer.send_past_1_day_reminder(@mailer_certificate, 'john@mailinator.com').deliver
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
