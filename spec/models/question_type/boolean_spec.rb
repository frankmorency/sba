require 'rails_helper'

RSpec.describe QuestionType::Boolean, type: :model do
  before do
    @model = build(:boolean_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/boolean")
      end
    end
  end

  context "when the user has provided a valid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('yes', 'yes', nil)
      end

      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end

  context "when the user has provided a invalid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('no', 'yes', nil)
      end

      it 'should succeed' do
        expect(@outcome).to eq(Answer::FAILURE)
      end
    end
  end

end