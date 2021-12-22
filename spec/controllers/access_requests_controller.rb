require 'rails_helper'

RSpec.describe ContractingOfficer::AccessRequestsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryBot.create(:user)
    #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in @user
    @vendor_admin = FactoryBot.create(:user_random)
    @org = build(:organization)
    @org.users << @vendor_admin
    @org.save!
  end

  after do
    @user.destroy
    @org.destroy
    @vendor_admin.detroy
  end

  # There was no bug because AccessRequest line 58 set_defaults
  describe "#Create" do
    it 'should only send permited params to create the access request' do
      post 'create', { access_request: { id: 1, status: 'accepted', organization_id: @org, solicitation_number: 'ABCDEF', solicitation_naics: 'ABCDEF', role_id: 1, status: 'accepted' } }
      expect( AccessRequest.first.status).to eq("requested")
      sign_out
    end
  end
end 
