require 'rails_helper'

RSpec.describe AccessRequest, type: :model do
  it { is_expected.to belong_to(:user) }

  it 'should be searchable' do
    expect(AccessRequest).to respond_to(:sba_search)
  end

  before do
    @mailer = double(deliver: nil)
    @ar = create(:vendor_profile_access_request)
  end

  describe "#accept!" do
    context "when status is requested" do
      it 'should update the status to accepted and expiration and send an email' do
        @ar.accept!(@ar.user)
        expect(@ar).to be_accepted
        pr = PermissionRequest.where(access_request_id: @ar.id, action: 1).first
        expect(pr.action).to eq('accepted')
      end
    end

    context "when status is not requested" do
      it 'should do nothing' do
        @ar.status = "revoked"
        @ar.accept!(@ar.user)
        expect(@ar).to be_revoked
      end
    end
  end

  describe "#reject!" do
    context "when status is requested" do
      before do
        @ar.status = "requested"
      end

      it 'should update the status to rejected and send an email' do
        @ar.reject!(@ar.user)
        expect(@ar).to be_rejected
        pr = PermissionRequest.where(access_request_id: @ar.id, action: 2).first
        expect(pr.action).to eq('rejected')
      end
    end

    context "when status is not requested" do
      before do
        @ar.status = "revoked"
      end

      it 'should do nothing' do
        expect(ContractOfficerAccessRequestMailer).not_to receive(:access_request_accepted_email)
        @ar.reject!(@ar.user)
        expect(@ar).to be_revoked
      end
    end
  end

  describe "#revoke!" do
    before do
      @ar.status = "accepted"
    end
    it 'should update the status to revoked' do
      @ar.revoke!(@ar.user)
      expect(@ar).to be_revoked
        pr = PermissionRequest.where(access_request_id: @ar.id, action: 3).first
        expect(pr.action).to eq('revoked')
    end
  end

  context "when status is requested" do

    before do
      @ar.status = 'requested'
    end

    describe('#requested?') do
      it 'should be true' do
        expect(@ar).to be_requested
      end
    end

    describe('#accepted?') do
      it '#accepted? should be false' do
        expect(@ar).not_to be_accepted
      end
    end

    describe('##revoked?') do
      it '#revoked? should be false' do
        expect(@ar).not_to be_revoked
      end
    end

    describe('#requested?') do
      it '##requested? should be false' do
        expect(@ar).not_to be_rejected
      end
    end
  end

  context "when status is accepted" do
    before do
      @ar.status = 'accepted'
    end

    describe "#requested?" do
      it 'should be false' do
        expect(@ar).not_to be_requested
      end
    end

    describe "#revoked?" do
      it 'should be false' do
        expect(@ar).not_to be_revoked
      end
    end

    describe "#rejected?" do
      it 'should be false' do
        expect(@ar).not_to be_rejected
      end
    end
  end

  context "when status is revoked" do
    before do
      @ar.status = 'revoked'
    end

    describe "#requested?" do
      it 'should be false' do
        expect(@ar).not_to be_requested
      end
    end

    describe "#accepted?" do
      it 'should be false' do
        expect(@ar).not_to be_accepted
      end
    end

    describe "#rejected?" do
      it 'should be false' do
        expect(@ar).not_to be_rejected
      end
    end

    describe "#revoked?" do
      it 'should be true' do
        expect(@ar).to be_revoked
      end
    end
  end

  context "when status is accepted" do
    before do
      @ar.status = 'accepted'
    end

    describe "#revoked?" do
      it 'should be false' do
        expect(@ar).not_to be_revoked
      end
    end

    describe "#requested?" do
      it 'should be false' do
        expect(@ar).not_to be_requested
      end
    end

    describe "#accepted?" do
      it 'should be true' do
        expect(@ar).to be_accepted
      end
    end
  end

  context "defaults" do
    before do
      @ar = AccessRequest.new
      @ar.valid?
    end

    describe "#status" do
      it 'should be "requested"' do
        expect(@ar.status).to eq('requested')
      end
    end

    describe "#request_expires_on" do
      it 'should be 7 days from now' do
        expect(@ar.request_expires_on).to eq(7.days.from_now.to_date)
      end
    end
  end
end
