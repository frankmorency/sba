require 'rails_helper'

class NotificationsHelperTester
  include NotificationsHelper
end

RSpec.describe Review::EightAInitial, type: :model do

  describe "#determination_made_sba_approved" do

    let(:eighta_review) { Review::EightAInitial.new(certificate: FactoryBot.create(:eight_a_certificate_determination)) }
    let(:vendor_user) { FactoryBot.create(:vendor_user_with_org) }
    let(:eight_a_user) { FactoryBot.create(:eight_a_user) }

    [ ['approved', :determination_made_sba_approved], ['declined', :determination_made_decline_ineligible] ].each do |subtype, det_method|
      it "sends a #{subtype} notification" do
        sba_app = double('SbaApplication', id: 999, users: [vendor_user], organization: vendor_user.organizations.first, kind: 'initial')
        allow(eighta_review).to receive(:sba_application).and_return(sba_app)
        allow(eighta_review).to receive(:current_owner).and_return(eight_a_user)

        det_made_vendor_args = [ "8(a)", "Initial", subtype, vendor_user.id, sba_app.id, vendor_user.email ]
        det_made_user_args = [ "8(a)", "Initial", subtype, eight_a_user.id, sba_app.id, eight_a_user.email ]

        expect(eighta_review).to receive(:send_notification_determination_made).with(*det_made_vendor_args)
        # expect(eighta_review).to receive(:send_notification_determination_made).with(*det_made_user_args)
        eighta_review.send det_method
      end
    end
  end

  describe "NotificationsHelper#send_notification_determination_made" do

    let(:helper_tester) { NotificationsHelperTester.new }
    let(:obj) do
      {
          strict: false,
          event_type: 'application_status_change',
          subtype: "some_subtype",
          recipient_id: "some_recipient_id",
          application_id: "some_application_id",
          email: "some_email",
          certify_link: "/sba_applications/some_application_id/conversations",
          options:{ program_name: "some_program", application_type: "some_application_type" }
      }
    end

    it 'calls run_notification with correct arguments' do
      expect(helper_tester).to receive(:run_notification).with(obj)
      opts = obj[:options]
      helper_tester.send_notification_determination_made(opts[:program_name], opts[:application_type], obj[:subtype],
                                                         obj[:recipient_id], obj[:application_id], obj[:email])
    end
  end

end


RSpec.describe Review::EightAAnnualReview, type: :model do

  describe "#determination_made_sba_approved" do

    let(:eighta_review) { Review::EightAAnnualReview.new(certificate: FactoryBot.create(:eight_a_certificate_determination)) }
    let(:vendor_user) { FactoryBot.create(:vendor_user_with_org) }
    let(:eight_a_user) { FactoryBot.create(:eight_a_user) }

    [ ['approved', :determination_made_sba_approved], ['declined', :determination_made_decline_ineligible] ].each do |subtype, det_method|
      it "sends a #{subtype} notification" do
        sba_app = double('SbaApplication', id: 999, users: [vendor_user], organization: vendor_user.organizations.first, kind: 'annual_review')
        allow(eighta_review).to receive(:sba_application).and_return(sba_app)
        allow(eighta_review).to receive(:current_owner).and_return(eight_a_user)
        det_made_args = [ "8(a)", "Annual Review", subtype, vendor_user.id, sba_app.id, vendor_user.email ]
        expect(eighta_review).to receive(:send_notification_determination_made).with(*det_made_args)
        eighta_review.send det_method
      end
    end
  end

  describe "NotificationsHelper#send_notification_determination_made" do

    let(:helper_tester) { NotificationsHelperTester.new }
    let(:obj) do
      {
          strict: false,
          event_type: 'application_status_change',
          subtype: "some_subtype",
          recipient_id: "some_recipient_id",
          application_id: "some_application_id",
          email: "some_email",
          certify_link: "/sba_applications/some_application_id/conversations",
          options:{ program_name: "some_program", application_type: "some_application_type" }
      }
    end

    it 'calls run_notification with correct arguments' do
      expect(helper_tester).to receive(:run_notification).with(obj)
      opts = obj[:options]
      helper_tester.send_notification_determination_made(opts[:program_name], opts[:application_type], obj[:subtype],
                                                         obj[:recipient_id], obj[:application_id], obj[:email])
    end
  end

end
