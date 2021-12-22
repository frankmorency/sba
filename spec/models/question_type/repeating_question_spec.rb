require 'rails_helper'

RSpec.describe QuestionType::RepeatingQuestion, type: :model do
  before do
    @model = build(:repeating_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/repeating_question")
      end
    end
  end

  context "when the user has provided a valid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('whatever', 'whatever', nil)
      end

      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end

  context "when the user has provided a invalid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('asdfcasdfasdf', 'whatever', nil)
      end

      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end
end