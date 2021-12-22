require 'rails_helper'

RSpec.describe QuestionType::TextField, type: :model do
  before do
    @model_single = build(:text_field_single_line)
    @model_multi = build(:text_field_multiline)
    @invalid_model = build(:text_field_invalid)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome_single = @model_single.partial()
        @outcome_multi = @model_multi.partial()
      end

      it 'should succeed for single line question' do
        expect(@outcome_single).to eq('question_types/text_field')
      end

      it 'should succeed for multiline question' do
        expect(@outcome_multi).to eq('question_types/text_field')
      end
    end
  end

  context "when the user has provided invalid num_lines value" do
    describe "#validate_num_lines_value" do
      it 'should raise an error' do
        expect {@invalid_model.validate_num_lines_value}.to raise_error(/^Please include a valid number of lines value/)
      end
    end
  end

  context "when the user has provided non-integer min value" do
    describe "#validate_min" do
      it 'should raise an error' do
        expect {@invalid_model.validate_min}.to raise_error(/^Character length value must be an integer/)
      end
    end
  end
end