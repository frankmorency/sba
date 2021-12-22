require 'rails_helper'
require 'workflow'

RSpec.describe Review, type: :model do
  it { is_expected.to belong_to(:certificate) }

  before do
    @review = Review.new
  end

  describe "#certificate" do
    it 'should be required' do
      expect(@review).not_to be_valid
      expect(@review.errors[:certificate]).to include("can't be blank")
    end
  end
end


RSpec.describe ApplicationReview, type: :model do
  it { is_expected.to belong_to(:sba_application) }

  before do
    @review = ApplicationReview.new
  end

  describe "#sba_application" do
    it 'should be required' do
      expect(@review).not_to be_valid
      expect(@review.errors[:sba_application]).to include("can't be blank")
    end
  end
end

RSpec.describe Review, type: :model do
  it { is_expected.to have_many(:assignments) }
  it { is_expected.to have_many(:assessments) }
  it { is_expected.to belong_to(:current_assignment) }

  before do
    @sba_application = create(:eight_a_display_application_initial, workflow_state: 'draft')
    @eight_a_cert = create(:certificate_eight_a)
    @sba_application.update_attribute(:certificate_id, @eight_a_cert)
    @sba_application.save(validate: false)
    @review = create(:review_for_eight_a)
    @review.sba_application = @sba_application
    @review.save(validate: false)
  end

  context "new" do
    before do
#      @existing_review = create(:review)

      @review = build(:review, case_number: nil)
    end

    describe "#case_number" do
      it 'should set automatically before validation' do
        expect(@review.case_number).to be_nil
        @review.valid?
        expect(@review.case_number).to be_a(String)
        expect(@review.case_number).to match(/\A[A-Z][A-Z]\d+\z/)
      end

      # it 'should be unique' do
      #   @review.valid?
      #   @review.case_number = @existing_review.case_number
      #
      #   expect(@review).not_to be_valid
      #   expect(@review.errors.on(:case_number)).to eq([])
      # end
    end
  end

  context "when the workflow_state is recommend ineligible" do
    before do
      @review.workflow_state = :recommend_ineligible
    end

    describe "#vendor_status" do
      it 'should be Assigned in Progress' do
        expect(@review.vendor_status).to eq('Assigned In Progress')
      end
    end
  end

  context "when the workflow_state is recommend eligible" do
    before do
      @review.workflow_state = :recommend_eligible
    end

    describe "#vendor_status" do
      it 'should be Assigned in Progress' do
        expect(@review.vendor_status).to eq('Assigned In Progress')
      end
    end
  end

  %w(cancelled unassigned assigned_in_progress returned_for_modification decided_ineligible decided_eligible).each do |ws|
    context "when the workflow_state is #{ws}" do
      before do
        @review.workflow_state = ws
      end

      describe "#vendor_status" do
        it "should be #{ws.titleize}" do
          expect(@review.vendor_status).to eq(ws.titleize)
        end
      end
    end
  end

  describe "#closed_automatically?" do
    context "when the workflow_state is closed" do
      before do
        @review.update_attribute(:workflow_state, 'closed')
      end

      context "when the review is 55 days or older" do
        before do
          @review.update_attributes!(reconsideration_or_appeal_clock: 55.days.ago)
        end

        it 'should return true' do
          expect(@review.closed_automatically?).to be_truthy
        end
      end

      context "when the review is 54 days or newer" do
        before do
          @review.update_attributes!(reconsideration_or_appeal_clock: 54.days.ago)
        end

        it 'should return false' do
          expect(@review.closed_automatically?).to be_falsey
        end
      end
    end
  end
end
