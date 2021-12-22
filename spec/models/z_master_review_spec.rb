require 'rails_helper'
require 'workflow'

RSpec.describe Review::EightAInitial, type: :model do
  before do
    @review = Review::EightAInitial.new
  end

  describe "#certificate" do
    it 'should be required' do
      expect(@review).not_to be_valid
      expect(@review.errors[:certificate]).to include("can't be blank")
    end
  end

  describe ".create_and_assign_review" do
    before do
      @certificate = build(:certificate_eight_a)
      @app = create(:basic_application, organization: @certificate.organization)
      @certificate.sba_applications << @app
      @certificate.save!
    end

    context "when you're an 8a cods analyst" do
      before do
        @user = create(:eight_a_cods_analyst_user)
        @review = Review::EightAInitial.create_and_assign_review(@user, @app)
      end

      it 'should create an assignment' do
        expect(@review.current_assignment).not_to be_nil
        expect(@review.current_assignment.reviewer).to eq(@user)
      end

      it 'should create a review in a screening state' do
        expect(@review).not_to be_nil
        expect(@review.workflow_state).to eq(Review::EightA::SCREENING)
      end

      it 'should set the screening due date' do
        expect(@review.screening_due_date).to eq(15.days.from_now.to_date)
      end
    end

    context "when you're another sba role" do
      before do
        @user = create(:analyst_user)
      end

      it 'should not create a review' do
        expect(Review::EightAInitial.create_and_assign_review(@user, @app)).to be_nil
      end
    end

    context "when application has not been assigned to an analyst" do
      describe "#current_reviewer" do
        it 'should be nil' do
          expect(@review.current_reviewer).to be_nil
        end
      end
      describe "#current_owner" do
        it 'should be nil' do
          expect(@review.current_owner).to be_nil
        end
      end
    end

    context "when application has been assigned to an analyst" do
      before do
        @assigned_user = create(:eight_a_cods_analyst_user)
        @unassigned_user = create(:user)
        @review = Review::EightAInitial.create_and_assign_review(@assigned_user, @app)
      end

      describe "#user_is_reviewer_or_owner" do
        it 'should be assigned user' do
          expect(@review.user_is_reviewer_or_owner(@assigned_user)).to be_truthy
        end

        it 'should not be unassigned user' do
          expect(@review.user_is_reviewer_or_owner(@unassigned_user)).to be_falsey
        end
      end

      describe "#current_reviewer" do
        it 'should be assigned user' do
          expect(@review.current_reviewer).to eq(@assigned_user)
        end

        it 'should not be unassigned_user' do
          expect(@review.current_reviewer).not_to eq(@unassigned_user)
        end
      end

      describe "#current_owner" do
        it 'should be assigned user' do
          expect(@review.current_owner).to eq(@assigned_user)
        end

        it 'should not be unassigned user' do
          expect(@review.current_owner).not_to eq(@unassigned_user)
        end
      end
    end
  end
end
