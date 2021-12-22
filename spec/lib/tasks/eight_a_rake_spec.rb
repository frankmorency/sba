require 'rails_helper'
require 'rake'
include ActiveSupport::Testing::TimeHelpers
load File.expand_path("../../../../lib/tasks/eight_a.rake", __FILE__)

describe "eight_a:create_annual_reviews_daily" do
  before do
    org = create(:org_with_user)
    user = org.users.first
    cert_type = CertificateType::EightA.first
    @cert = create(:certificate_eight_a_initial, workflow_state: 'active',
                                                 organization_id: org.id,
                                                 certificate_type: cert_type)
    Rake::Task["eight_a:create_annual_reviews_daily"].reenable # allows .invoke to run again
    ActionMailer::Base.deliveries = [] # resets email deliveries
  end

  describe "8a certificate was issued" do

    describe "30 days ago" do
      before do
        @cert.update_attributes(issue_date: (30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'does not create an annual review and no emails are sent' do
        expect(@cert.current_application).to eq(nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    describe "in January of this year and we are in December" do
      before do
        @last_december = Date.new(1.year.ago.year, 12, 15)
        travel_to @last_december do
          @cert.update_attributes(issue_date: (1.year.ago + 30.days))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:create_annual_reviews_daily"].invoke
        end
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(@last_december + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "1 year + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (1.year.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "2 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (2.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "3 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (3.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "4 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (4.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "5 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (5.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "6 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (6.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "7 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (7.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "8 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (8.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'creates annual review and sends reminder email' do
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 60.days).to_date.strftime('%m/%d/%Y')}."
        expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
      end
    end

    describe "9 years + 30 days ago" do
      before do
        @cert.update_attributes(issue_date: (9.years.ago + 30.days))
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'does not create an annual review and no emails are sent' do
        expect(@cert.current_application).to eq(nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end

  describe "8a certificate has finalized adverse action" do

    describe "Status is terminated" do
      before do
        @cert.update_attributes(issue_date: (1.year.ago + 30.days))
        @cert.update_attribute(:workflow_state, "terminated")
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'does not create an annual review and no emails are sent' do
        expect(@cert.current_application).to eq(nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    describe "Status is early_graduated" do
      before do
        @cert.update_attributes(issue_date: (1.year.ago + 30.days))
        @cert.update_attribute(:workflow_state, "early_graduated")
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'does not create an annual review and no emails are sent' do
        expect(@cert.current_application).to eq(nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    describe "Status is voluntary_withdrawn" do
      before do
        @cert.update_attributes(issue_date: (1.year.ago + 30.days))
        @cert.update_attribute(:workflow_state, "voluntary_withdrawn")
        Rake::Task.define_task(:environment)
        Rake::Task["eight_a:create_annual_reviews_daily"].invoke
      end

      it 'does not create an annual review and no emails are sent' do
        expect(@cert.current_application).to eq(nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end

describe "eight_a:send_reminder_on_anniversary_date" do

  describe "Claimed Firms" do
    before do
      # @organization = create(:organization)
      org = create(:org_with_user)
      user = org.users.first
      cert_type = CertificateType::EightA.first
      @cert = create(:certificate_eight_a_initial, workflow_state: 'active',
                                                   organization_id: org.id,
                                                   certificate_type: cert_type)
      Rake::Task["eight_a:send_reminder_on_anniversary_date"].reenable # allows .invoke to run again
      ActionMailer::Base.deliveries = [] # resets email deliveries
    end

    describe "8a certificate was issued" do

      describe "30 days ago" do
        before do
          @cert.update_attributes(issue_date: (30.days.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'does not send a 2nd annual review reminder email' do
          expect(@cert.current_application).to eq(nil)
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      describe "1 year ago" do
        before do
          @cert.update_attributes(issue_date: (1.year.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "2 years ago" do
        before do
          @cert.update_attributes(issue_date: (2.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "3 years ago" do
        before do
          @cert.update_attributes(issue_date: (3.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "4 years ago" do
        before do
          @cert.update_attributes(issue_date: (4.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "5 years ago" do
        before do
          @cert.update_attributes(issue_date: (5.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "6 years ago" do
        before do
          @cert.update_attributes(issue_date: (6.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "7 years ago" do
        before do
          @cert.update_attributes(issue_date: (7.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "8 years ago" do
        before do
          @cert.update_attributes(issue_date: (8.years.ago))
          @cert.organization.create_eight_a_annual_review!
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends 2nd annual review reminder email' do
          expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "9 years ago" do
        before do
          @cert.update_attributes(issue_date: (9.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'does not send a 2nd annual review reminder email' do
          expect(@cert.current_application).to eq(nil)
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end
    end
  end


  describe "Unclaimed Firms" do
    before do
      org = create(:organization)
      ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations(duns, tax_identifier_number, tax_identifier_type, sam_extract_code, govt_bus_poc_email, govt_bus_poc_first_name, govt_bus_poc_last_name) VALUES ('#{org.duns_number}', '#{org.tax_identifier}', '#{org.tax_identifier_type}', 'A', 'nomail@mailinator.com', 'John', 'Smith');")
      MvwSamOrganization.refresh
      cert_type = CertificateType::EightA.first
      @cert = create(:certificate_eight_a_initial, workflow_state: 'active',
                                                   organization_id: org.id,
                                                   certificate_type: cert_type)
      Rake::Task["eight_a:send_reminder_on_anniversary_date"].reenable # allows .invoke to run again
      ActionMailer::Base.deliveries = [] # resets email deliveries
    end

    describe "8a certificate was issued" do

      describe "30 days ago" do
        before do
          @cert.update_attributes(issue_date: (30.days.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'does not send a 2nd annual review reminder email' do
          expect(@cert.current_application).to eq(nil)
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      describe "1 year ago" do
        before do
          @cert.update_attributes(issue_date: (1.year.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "2 years ago" do
        before do
          @cert.update_attributes(issue_date: (2.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "3 years ago" do
        before do
          @cert.update_attributes(issue_date: (3.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "4 years ago" do
        before do
          @cert.update_attributes(issue_date: (4.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "5 years ago" do
        before do
          @cert.update_attributes(issue_date: (5.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "6 years ago" do
        before do
          @cert.update_attributes(issue_date: (6.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "7 years ago" do
        before do
          @cert.update_attributes(issue_date: (7.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "8 years ago" do
        before do
          @cert.update_attributes(issue_date: (8.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'sends sam org 2nd annual review reminder email' do
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          subject = "Your 8(a) Annual Review is due in Certify on #{(Date.today + 30.days).to_date.strftime('%m/%d/%Y')}."
          expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
        end
      end

      describe "9 years ago" do
        before do
          @cert.update_attributes(issue_date: (9.years.ago))
          Rake::Task.define_task(:environment)
          Rake::Task["eight_a:send_reminder_on_anniversary_date"].invoke
        end

        it 'does not send a 2nd annual review reminder email' do
          expect(@cert.current_application).to eq(nil)
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end
    end
  end

end
