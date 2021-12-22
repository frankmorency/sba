require 'rails_helper'

RSpec.describe Api::V1::CertificationsController, type: :controller do
  include Devise::TestHelpers

  render_views

  describe '#index' do
    it "returns nothing if nothing in the database" do
      expect(Organization).to receive(:all).and_return([])

      get 'index', format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to eq '[]'
    end

    describe "with organizations" do
      before do
        @org = build(:organization)
        sam_org = OpenStruct.new(
          duns: 'duns-number'
        )

        allow(@org).to receive(:get_corresponding_sam_organization).and_return(sam_org)
      end

      describe "with no certifications" do
        it "returns the org with no certifications" do
          expect(Organization).to receive(:all).and_return([@org])
          expect(@org).to receive_message_chain(:certificates, :not_expired, :with_active_state).and_return([])

          get 'index', format: :json
          expect(response).to have_http_status(200)
          expect(response.body).to eq %Q[[{"duns":"#{@org.duns_number}","certifications":[]}]]
        end
      end

      describe "with certificates" do
        it "returns the org with the certificates" do
          certs = [
            build(:certificate_for_determination, certificate_type: build(:wosb_cert, title: "WOSB")),
            build(:certificate_for_determination, certificate_type: build(:edwosb_cert, title: "EDWOSB"))
          ]

          expect(Organization).to receive(:all).and_return([@org])
          expect(@org).to receive_message_chain(:certificates, :not_expired, :with_active_state).and_return(certs)

          get 'index', format: :json
          expect(response).to have_http_status(200)
          wosb_json = %q[{"type":"WOSB","started_on":null,"ended_on":null}]
          edwosb_json = %q[{"type":"EDWOSB","started_on":null,"ended_on":null}]
          expect(response.body).to eq %Q[[{"duns":"#{@org.duns_number}","certifications":[#{wosb_json},#{edwosb_json}]}]]
        end
      end
    end
  end
end
