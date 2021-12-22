require 'rails_helper'
require 'date'

RSpec.describe QuestionType::Currency, type: :model do
  before do
    @model = build(:currency_question_type)
  end

  context "when the user has provided a valid currency" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('1000.00', nil)
      end
      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end

  context "when the user has provided an invalid currency" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate("123abc.00", nil)
      end

      it 'should fail' do
        expect(@outcome).to eq(Answer::FAILURE)
      end
    end
  end
end