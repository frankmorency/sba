if Feature.active?(:idp)

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do

  describe "#sba_idp" do
    context "vendor_admin" do
      let(:vendor_admin) {create :vendor_admin}
      it 'gets redirected to his/her dashboard' do
        allow(User).to receive(:from_omniauth).with(anything).and_return(vendor_admin)
        allow(subject).to receive(:redirect_to).with(subject.after_sign_in_path_for(vendor_admin)).and_return(subject.after_sign_in_path_for(vendor_admin))

        expect(subject.sba_idp).to eq(subject.after_sign_in_path_for(vendor_admin))
        expect(flash[:info]).to match("Logging in via SBA-IDP.")
      end
    end

    context "invalid user" do
      let(:vendor_admin) {create :vendor_admin}
      it 'gets redirected to root_path' do
        allow(User).to receive(:from_omniauth).with(anything).and_return(User.new)
        allow(subject).to receive(:redirect_to).with(subject.root_path).and_return(subject.root_path)

        expect(subject.sba_idp).to eq(subject.root_path)
        expect(flash[:error]).to match("Login Failed.")
      end
    end
  end
end
end
