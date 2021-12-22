require 'rails_helper'

RSpec.describe QuestionType::DateRange, type: :model do
  before do
    @model = build(:date_range_type)
  end

  context 'return the correct view' do
    describe '#partial' do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq('question_types/date_range')
      end
    end
  end
end