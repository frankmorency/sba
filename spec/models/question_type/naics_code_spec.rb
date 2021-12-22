require 'rails_helper'

RSpec.describe QuestionType::NaicsCode, type: :model do
  before do
    @model = build(:naics_code_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/naics_code")
      end
    end
  end
end