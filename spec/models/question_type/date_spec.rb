require 'rails_helper'
require 'date'

RSpec.describe "QuestionType::Date", type: :model do
  before do
    @model = build(:date_question_type)
  end

  context "when the user has provided a valid date - mm/dd/yyyy format" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('01/01/2016', nil)
      end

      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end

  context "when the user has provided an invalid date" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate("02/30/2016", nil)
      end

      it 'should fail' do
        expect(@outcome).to eq(Answer::FAILURE)
      end
    end
  end

  context "when the user has provided an invalid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate("abcd123/2004", nil)
      end

      it 'should fail' do
        expect(@outcome).to eq(Answer::FAILURE)
      end
    end
  end
end