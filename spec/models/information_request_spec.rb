require 'rails_helper'

RSpec.describe InformationRequest, type: :model do
  describe "creating an application" do
    before do
      @organization = create :org_with_user
      @cert = Certificate::EightA.new organization: @organization, certificate_type: CertificateType::EightA.first, workflow_state: 'active'
      @cert.save(validate: false)

      @info_request = InformationRequest.new(
        organization_id: @organization.id,
        topic: "this is my question",
        message_to_firm_owner: "this is more information about the question",
        text: '1'
      )

      @info_request.create_application!
    end

    xit 'should create an info request application and adhoc subapp for the org' do
      @info_request_app = @organization.sba_applications.where(kind: 'info_request').first
      @adhoc_app = @info_request_app.sub_applications.first

      expect(@organization.sba_applications.where(kind: 'info_request').count).to eq(1)
      expect(@info_request_app).to be_a(SbaApplication::EightAInfoRequest)
      expect(@info_request_app).to be_a(SbaApplication::MasterApplication)
      expect(@info_request_app.app_overview_title).to eq("8(a) Info Request")
      expect(@info_request_app.sub_applications.count).to eq(1)

      expect(@adhoc_app).to be_a(SbaApplication::SubApplication)
      expect(@adhoc_app.kind).to eq('initial') # because it's not _really_ an adhoc from a workflow sense
      expect(@adhoc_app.root_section.name).to eq('adhoc_text_root')
    end
  end
end
