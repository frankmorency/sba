require 'rails_helper'

RSpec.describe ReviewsHelper, type: :helper do
  describe "#next_analyst_review_step" do
    before do

      @current_step_question_review = 'sba_analyst/question_reviews'
      @current_step_financial_review = 'sba_analyst/financial_reviews'
      @current_step_signature_review = 'sba_analyst/signature_reviews'
      @current_step_determinations = 'sba_analyst/determinations'
      @current_step_other = 'other'

      @ordered_answered_for_ids = [1, 2, 3, 4, 5]

      @review = double(id: 'DB1482334324')

      allow(Rails.application).to receive_message_chain(:routes, :url_helpers, :new_sba_analyst_review_determination_path).and_return('/sba_analyst/reviews/DB1482334324/determinations/new')
      allow(Rails.application).to receive_message_chain(:routes, :url_helpers, :new_sba_analyst_review_financial_review_path).and_return('/sba_analyst/reviews/DB1482334324/financial_review/new')
      allow(Rails.application).to receive_message_chain(:routes, :url_helpers, :new_sba_analyst_review_signature_review_path).and_return('/sba_analyst/reviews/DB1482334324/signature_review/new')

    end

    context 'when coming from an unexpected step (controller)' do
      it 'should send the user back to that controller' do
        expect(helper.next_analyst_review_step(@current_step_other, @review)).to eq(:back)
      end
    end

    context 'when coming from the Determinations step' do
      it 'should send the user back to the Determinations step' do
        expect(helper.next_analyst_review_step(@current_step_determinations, @review)).to eq(:back)
      end
    end

    context 'when coming from the Signature Review step' do
      it 'should send the user to the Determinations step' do
        expect(helper.next_analyst_review_step(@current_step_signature_review, @review)).to eq(new_sba_analyst_review_determination_path(@review))
      end
    end

    context 'when coming from the Financial Review step AND is on the first owner' do
      it 'should send the user to the next owner in the Financial Review step' do
        expect(helper.next_analyst_review_step(@current_step_financial_review, @review, @ordered_answered_for_ids, 1)).to eq(new_sba_analyst_review_financial_review_path(@review, owner: 2))
      end
    end

    context 'when coming from the Financial Review step AND is on middle owner' do
      it 'should send the user to the next owner in the Financial Review step' do
        expect(helper.next_analyst_review_step(@current_step_financial_review, @review, @ordered_answered_for_ids, 3)).to eq(new_sba_analyst_review_financial_review_path(@review, owner: 4))
      end
    end

    context 'when coming from the Financial Review step AND is on the last owner' do
      it 'should send the user to the Signature Review step' do
        expect(helper.next_analyst_review_step(@current_step_financial_review, @review, @ordered_answered_for_ids, 5)).to eq(new_sba_analyst_review_signature_review_path(@review))
      end
    end

    context 'when coming from the Financial Review step AND is on the last owner AND missing owner information' do
      it 'should send the user back to the Financial Review step' do
        expect(helper.next_analyst_review_step(@current_step_financial_review, @review, @ordered_answered_for_ids)).to eq(:back)
      end
    end

    context 'when coming from the Question Review step AND is MPP' do
      before do
        expect(@review).to receive(:certificate_type_name).and_return('mpp')
      end
      it 'should send the user to the Signature Review step' do
        expect(helper.next_analyst_review_step(@current_step_question_review, @review)).to eq(new_sba_analyst_review_signature_review_path(@review))
      end
    end

    context 'when coming from the Question Review step AND is WOSB' do
      before do
        expect(@review).to receive(:certificate_type_name).and_return('wosb')
      end
      it 'should send the user to the Signature Review step' do
        expect(helper.next_analyst_review_step(@current_step_question_review, @review)).to eq(new_sba_analyst_review_signature_review_path(@review))
      end
    end

    context 'when coming from the Question Review step AND is EDWOSB and application has financial section' do
      before do
        expect(@review).to receive(:certificate_type_name).and_return('edwosb')
      end
      it 'should send the user to the first owner in the Financial Review step' do
        expect(helper.next_analyst_review_step(@current_step_question_review, @review, @ordered_answered_for_ids)).to eq(new_sba_analyst_review_financial_review_path(@review, owner: 1))
      end
    end

    context 'when coming from the Question Review step AND is EDWOSB and application does not have financial section' do
      before do
        expect(@review).to receive(:certificate_type_name).and_return('edwosb')
      end
      it 'should send the user to the Signature Review step' do
        expect(helper.next_analyst_review_step(@current_step_question_review, @review, [])).to eq(new_sba_analyst_review_signature_review_path(@review))
      end
    end

  end
end