require 'rails_helper'

RSpec.describe QuestionType::CompositeQuestion, type: :model do
  before do
    @model = build(:composite_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/composite_question")
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