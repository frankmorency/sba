require 'rails_helper'

RSpec.describe Permissions, type: :model do
  describe 'can_send_deficiency_letter_in_processsing?' do
    let(:permission) { Permissions.new}
    context "affirmative" do
      before do
        permission.review = Review::EightAAnnualReview.new
        allow(permission).to receive(:is_application_with_SBA?).and_return(true)
        allow(permission).to receive(:is_case_owner?).and_return(true)
        allow(permission).to receive(:review_status).and_return('processing')
      end

      it 'should return true' do
        expect(permission.can_send_deficiency_letter_in_processsing?).to be_truthy
      end
    end

    context "negative" do
      before do
        permission.review = Review.new
        allow(permission).to receive(:is_application_with_SBA?).and_return(false)
        allow(permission).to receive(:is_case_owner?).and_return(false)
        allow(permission).to receive(:review_status).and_return('screening')
      end

      it 'should return false' do
        expect(permission.can_send_deficiency_letter_in_processsing?).to be_falsy
      end
    end
  end
end