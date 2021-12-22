require 'rails_helper'

RSpec.describe QuestionType::CertifyEditableTable, type: :model do
  before do
    @model = build(:certify_editable_table_type)
  end

  context 'return the correct view' do
    describe '#partial' do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq('question_types/certify_editable_table')
      end
    end
  end
end