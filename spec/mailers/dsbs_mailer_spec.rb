require "rails_helper"

RSpec.describe  DsbsReportMailer, type: :mailer do
    let(:emails) {["chris@mailinator.com"]}
    let(:filename) {Rails.root + 'spec/fixtures/files/attachment.txt'}
    let(:mail) {DsbsReportMailer.send_email(emails, file_name).deliver_now}

    describe '#send_report' do
      # Send the email, then test that it got queued
      # email = DsbsReportMailer.send_email(emails, file_name).deliver_now
      before {ActionMailer::Base.deliveries = []}

      it 'has_an_empty_mail_queue' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end  

      it 'increments_the_mail_queue' do
        # Send the email, then test that it got queued
        email = DsbsReportMailer.send_email(emails, filename).deliver_now
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
end
