require 'rails_helper'

RSpec.describe QuestionType::DataEntryGrid, type: :model do
  before do
    @model = build(:data_entry_grid_type)
  end

  context 'return the correct view' do
    describe '#partial' do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq('question_types/data_entry_grid')
      end
    end
  end
end