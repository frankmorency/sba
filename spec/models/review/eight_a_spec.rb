require 'rails_helper'

RSpec.describe Review::EightA, type: :model do
  before do
    @sba_application = create(:eight_a_display_application_initial, workflow_state: 'draft')
    @eight_a_cert = create(:certificate_eight_a)
    @sba_application.update_attribute(:certificate_id, @eight_a_cert)
    @sba_application.save(validate: false)
    @review = create(:review_for_eight_a)
    @review.sba_application = @sba_application
    @review.save(validate: false)
  end

  describe "#clear_denied_statuses!" do

    context "when the review is 90 days or older" do
      before do
        @review.update_attributes!(reconsideration_or_appeal_clock: 90.days.ago)
      end

      context "and the status is pending_reconsideration_or_appeal" do
        before do
          @review.update_attribute(:workflow_state, 'pending_reconsideration_or_appeal')
        end

        it 'should return workflow_state state closed' do
          Review::EightA.clear_denied_statuses!
          @review.reload
          expect(@review.workflow_state).to eq('closed')
        end
      end

      context "and the status is pending_reconsideration" do
        before do
          @review.update_attribute(:workflow_state, 'pending_reconsideration')
        end

        it 'should return workflow_state state closed' do
          Review::EightA.clear_denied_statuses!
          @review.reload
          expect(@review.workflow_state).to eq('closed')
        end
      end

      context "and the status is appeal_intent" do
        before do
          @review.update_attribute(:workflow_state, 'appeal_intent')
        end

        it 'should return workflow_state state closed' do
          Review::EightA.clear_denied_statuses!
          @review.reload
          expect(@review.workflow_state).to eq('closed')
        end
      end

      context "and the status is sba_approved" do
        before do
          @review.update_attribute(:workflow_state, 'sba_approved')
        end

        it 'should return workflow_state state sba_approved' do
          Review::EightA.clear_denied_statuses!
          @review.reload
          expect(@review.workflow_state).to eq('sba_approved')
        end
      end

    end

    context "when the review is 89 days or newer" do
      before do
        @review.update_attributes!(reconsideration_or_appeal_clock: 89.days.ago)
      end

      context "and the status is pending_reconsideration_or_appeal" do
        before do
          @review.update_attribute(:workflow_state, 'pending_reconsideration_or_appeal')
        end

        it 'should return workflow_state state pending_reconsideration_or_appeal' do
          Review::EightA.clear_denied_statuses!
          @review.reload
          expect(@review.workflow_state).to eq('pending_reconsideration_or_appeal')
        end
      end
    end

  end

  describe "#returned_with_deficiency_letter_while_in_processing?" do
    context "deficiency letter sent from processing state" do
      let(:workflow_states) {[]}

      before do
        workflow_states << WorkflowChange.new(workflow_state: 'processing', created_at: Time.now)
        workflow_states << WorkflowChange.new(workflow_state: 'returned_with_deficiency_letter', created_at: Time.now)
        @review.workflow_changes = workflow_states
      end

      it "should return true" do
        expect(@review.returned_with_deficiency_letter_while_in_processing?).to be_truthy
      end
    end


    context "deficiency letter sent from non-processing state" do
      let(:workflow_states) {[]}

      before do
        workflow_states << WorkflowChange.new(workflow_state: 'screening', created_at: Time.now)
        workflow_states << WorkflowChange.new(workflow_state: 'returned_with_deficiency_letter', created_at: Time.now)
        @review.workflow_changes = workflow_states
      end

      it "should return true" do
        expect(@review.returned_with_deficiency_letter_while_in_processing?).to be_falsy
      end
    end
  end

  describe "#calculate_new_processing_due_date" do
    context "resubmission after deficiency letter sent from processing state" do
      before do
        processing_due_date = Time.now
        allow(@review).to receive(:returned_with_deficiency_letter_while_in_processing?).and_return(true)
      end

      it "retains the processing_due_date to current value" do
        processing_due_date = @review.processing_due_date
        expect(@review.send(:calculate_new_processing_due_date)).to eq(processing_due_date)
      end
    end

    context "resubmission after deficiency letter sent from processing state" do
      before do
        @review.processing_due_date = Time.now - 1.month
        @review.processing_pause_date = Time.now - 1.week
        allow(@review).to receive(:returned_with_deficiency_letter_while_in_processing?).and_return(false)
      end

      it "sets new processing_due_date" do
        processing_due_date = @review.processing_due_date + (Date.today - @review.processing_pause_date)
        expect(@review.send(:calculate_new_processing_due_date)).to eq(processing_due_date)
      end
    end
  end
end