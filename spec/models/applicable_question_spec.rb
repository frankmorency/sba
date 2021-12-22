require 'rails_helper'

RSpec.describe ApplicableQuestion, type: :model do
  it { is_expected.to belong_to(:evaluation_purpose) }
  it { is_expected.to belong_to(:question) }

  describe '#evaluate' do
    context 'when correctly answering' do
      context 'a boolean question' do
        before do
          @applicable_question = build(:wosb_aq_1)
          @answer = build(:answer_yes)
          @answer.question = @applicable_question.question
          @applicable_question.answer = @answer
        end

        it 'should succeed' do
          expect(@applicable_question.evaluate).to eq(Answer::SUCCESS)
        end
      end

      context 'a naics question' do
        before do
          allow(EligibleNaicCode).to receive(:exists?).and_return true

          @applicable_question = build(:edwosb_aq_2)
          @answer = build(:answer_naics)
          @answer.question = @applicable_question.question
          @applicable_question.answer = @answer
        end

        it 'should succeed' do
          expect(@applicable_question.evaluate).to eq(Answer::SUCCESS)
        end
      end
    end

    context 'when answering incorrectly' do
      context 'a boolean question' do
        before do
          @applicable_question = build(:wosb_aq_1)
          @answer = build(:answer_no)
          @answer.question = @applicable_question.question
          @applicable_question.answer = @answer
        end

        it 'should fail' do
          expect(@applicable_question.evaluate).to eq(Answer::FAILURE)
        end
      end

      context 'a naics question' do
        before do
          allow(EligibleNaicCode).to receive(:exists?).and_return false

          @applicable_question = build(:edwosb_aq_2)
          @answer = build(:answer_naics_wrong)
          @answer.question = @applicable_question.question
          @applicable_question.answer = @answer
        end

        it 'should be a definite maybe' do
          expect(@applicable_question.evaluate).to eq(Answer::SUCCESS)
        end
      end
    end

    context 'when answering the wrong question' do
      before do
        @applicable_question = build(:wosb_aq_1)
        @answer = build(:answer_yes)
        @answer.question = build(:wosb_question_2)
        @applicable_question.answer = @answer
      end

      it 'should raise an error' do
        expect { @applicable_question.evaluate }.to raise_error(/^Attempting to answer the wrong question/)
      end
    end

    context 'when answering an unknown question type' do
      before do
        @applicable_question = build(:wosb_aq_1)
        @answer = build(:answer_yes)
        @answer.question = @applicable_question.question
        @applicable_question.answer = @answer

        @applicable_question.question.question_type = QuestionType.new # an undefined type of question
      end

      it 'should raise an error' do
        expect do
          @applicable_question.evaluate
        end.to raise_error(/^Unknown question type/)
      end
    end

    context 'when the question is not answered' do
      before do
        @applicable_question = build(:wosb_aq_1)
      end

      it 'should raise an error' do
        expect { @applicable_question.evaluate }.to raise_error(/^Question not answered/)
      end
    end
  end
end
