require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to belong_to(:question) }

  describe 'disqualified?(qp)' do
    before do
      @qp = create(:amieligible_pres_1)
      @answer = create(:answer_boolean, question: @qp.question, value: {value: 'no'})
    end

    context 'when it is not a disqualifying question' do
      it 'should be false' do
        expect(@answer.disqualified?(@qp)).to be_falsey
      end
    end

    context 'when it is a disqualifying question' do
      before do
        @qp.create_disqualifier!(value: 'no', message: 'because i said so')
      end

      context 'and the answer is disqualifying' do
        before do
          # NOTE: Implicitly testing that the most recent answer is the one used
          @answer = create(:answer_boolean, question: @qp.question, value: {value: 'no'})
        end

        it 'should be true' do
          expect(@answer.disqualified?(@qp)).to be_truthy
        end
      end

      context 'and the answer is not disqualifying' do
        before do
          @answer = create(:answer_boolean, question: @qp.question, value: {value: 'yes'})
        end

        it 'should be false' do
          expect(@answer.disqualified?(@qp)).to be_falsey
        end
      end
    end
  end

  describe 'of type boolean' do
    before do
      @answer = build(:answer_boolean)
    end

    context 'when answer is yes' do
      before do
        @answer.value = {value: 'yes'}
      end

      describe "casted_value" do
        it 'should be true' do
          expect(@answer.casted_value).to eq(true)
        end
      end
    end

    context 'when answer is no' do
      before do
        @answer.value = {value: 'no'}
      end

      describe "casted_value" do
        it 'should be false' do
          expect(@answer.casted_value).to eq(false)
        end
      end
    end

    context 'when answer is nil' do
      before do
        @answer.value = {value: nil}
      end

      describe "casted_value" do
        it 'should be false' do
          expect(@answer.casted_value).to eq(false)
        end
      end
    end


    context 'when answer is some other garbage' do
      before do
        @answer.value = {value: 'asdfsd'}
      end

      describe "casted_value" do
        it 'should be false' do
          expect(@answer.casted_value).to eq(false)
        end
      end
    end
  end

  describe 'of type yes no na' do
    before do
      @answer = build(:answer_yes_no_na)
    end

    context 'when answer is yes' do
      before do
        @answer.value = {value: 'yes'}
      end

      describe "casted_value" do
        it 'should be Answer::SUCCESS' do
          expect(@answer.casted_value).to eq(Answer::SUCCESS)
        end
      end
    end

    context 'when answer is no' do
      before do
        @answer.value = {value: 'no'}
      end

      describe "casted_value" do
        it 'should be Answer::FAILURE' do
          expect(@answer.casted_value).to eq(Answer::FAILURE)
        end
      end
    end

    context 'when answer is NA' do
      before do
        @answer.value = {value: 'na'}
      end

      describe "casted_value" do
        it 'should be Answer::MAYBE' do
          expect(@answer.casted_value).to eq(Answer::MAYBE)
        end
      end
    end

    context 'when answer is nil' do
      before do
        @answer.value = {value: nil}
      end

      describe "casted_value" do
        it 'should be Answer::MAYBE' do
          expect(@answer.casted_value).to eq(Answer::MAYBE)
        end
      end
    end

    context 'when answer is some other garbage' do
      before do
        @answer.value = {value: 'asdfsd'}
      end

      describe "casted_value" do
        it 'should be Answer::MAYBE' do
          expect(@answer.casted_value).to eq(Answer::MAYBE)
        end
      end
    end
  end

  describe 'of type date' do
    before do
      @answer = build(:answer_date)
    end

    context 'when answer is a valid date' do
      before do
        @answer.value = {value: '2010-12-29'}
      end

      describe "casted_value" do
        it 'should cast the date' do
          expect(@answer.casted_value).to be_a(Date)
          expect(@answer.casted_value.year).to eq(2010)
          expect(@answer.casted_value.day).to eq(29)
          expect(@answer.casted_value.month).to eq(12)
        end
      end
    end

    context 'when answer is a normally formatted date' do
      before do
        @answer.value = {value: '5/12/2010'}
      end

      describe "casted_value" do
        it 'should cast the date' do
          expect(@answer.casted_value).to be_a(Date)
          expect(@answer.casted_value.year).to eq(2010)
          expect(@answer.casted_value.day).to eq(12)
          expect(@answer.casted_value.month).to eq(5)
        end
      end
    end

    context 'when answer is an invalid date' do
      before do
        @answer.value = {value: 'asdf3asdfas'}
      end

      describe "casted_value" do
        it 'should raise an error' do
          expect { @answer.casted_value }.to raise_error(StandardError)
        end
      end
    end
  end

  describe 'of type currency' do
    before do
      @answer = build(:answer_currency)
    end

    context 'when answer is a valid number' do
      before do
        # handle commas, etc.
        @answer.value = {value: '3030.35'}
      end

      describe "casted_value" do
        it 'should cast to big decimal' do
          expect(@answer.casted_value).to eq(BigDecimal('3030.35'))
        end
      end
    end

    context 'when answer is an invalid number' do
      before do
        @answer.value = {value: 'asdfasdf'}
      end

      # describe "casted_value" do
      #   it 'should equal zero' do
      #     expect(@answer.casted_value).to eq(0)
      #   end
      # end
    end
  end

  describe 'of type percentage' do
    before do
      @answer = build(:answer_percentage)
    end

    context 'when answer is a valid percentage' do
      before do
        # handle commas, etc.
        @answer.value = {value: '40.29'}
      end

      describe "casted_value" do
        it 'should cast to big decimal' do
          # handle > 100%, etc.
          expect(@answer.casted_value).to eq(BigDecimal('.4029'))
        end
      end
    end

    context 'when answer is an invalid number' do
      before do
        @answer.value = {value: 'asdfasdf'}
      end

      # describe "casted_value" do
      #   it 'should equal zero' do
      #     expect(@answer.casted_value).to eq(0)
      #   end
      # end
    end
  end

  describe 'of type address' do
    before do
      @answer = build(:answer_address)
    end

    describe "casted_value" do
      it 'should just be the address' do
        expect(@answer.casted_value).to eq(@answer.display_value)
      end
    end
  end

  describe 'of type picklist' do
    before do
      @answer = build(:answer_picklist)
    end

    describe "casted_value" do
      it 'should just be the picklist' do
        expect(@answer.casted_value).to eq(@answer.display_value)
      end
    end
  end

  describe 'of type naics_code' do
    before do
      @answer = build(:answer_naics_code)
    end

    describe "casted_value" do
      it 'should just be the naics code' do
        expect(@answer.casted_value).to eq(@answer.display_value)
      end
    end
  end
end
