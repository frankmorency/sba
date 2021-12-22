require 'rails_helper'

RSpec.describe QuestionType::FullAddress, type: :model do
  before do
    @model = build(:full_address_type)
  end

  context 'return the correct view' do
    describe '#partial' do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq('question_types/full_address')
      end
    end
  end
end