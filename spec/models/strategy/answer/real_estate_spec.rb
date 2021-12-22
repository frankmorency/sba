require 'rails_helper'
require_relative '../../../../app/models/question_type/date'

RSpec.describe Strategy::Answer::RealEstate, type: :model do
  before do
    QuestionType::Boolean.create name: 'yesno', title: 'Yes or No'
    QuestionType::Address.create name: 'address', title: 'Address'
    QuestionType::Date.create name: 'date', title: 'Date'
    QuestionType::Percentage.create name: 'percentage', title: 'Percentage'
    QuestionType::Currency.create name: 'currency', title: 'Currency'
    QuestionType::Picklist.create name: 'picklist', title: 'Picklist'

    @user = build(:user)
    @presentation = build(:real_estate_question_presentation)
  end

  context 'when given multiple real estate properties' do
    before do
      @data = {
          'question_text' => 'List your other real estate holdings:',
          'question_name' => 'other_real_estate',
          'answered_for_type' => 'BusinessPartner',
          'answered_for_id' => '1',
          '0' => {
              '0' => {
                  'question_text' => 'What type of Other Real Estate do you own?',
                  'question_name' => 'real_estate_type',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'Industrial'
              },
              '1' => {
                  'question_text' => 'What is the address of your Other Real Estate?',
                  'question_name' => 'real_estate_address',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '121 Madison Ave'
              },
              '2' => {
                  'question_text' => 'Is your Other Real Estate jointly owned?',
                  'question_name' => 'real_estate_jointly_owned',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'yes'
              },
              '3' => {
                  'question_text' => 'What percentage of ownership do you have in your Other Real Estate?',
                  'question_name' => 'real_estate_jointly_owned_percent',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '80'
              },
              '4' => {
                  'question_text' => 'What percentage of the mortgage are you responsible for in your Other Real Estate?',
                  'question_name' => 'real_estate_percent_of_mortgage',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '50'
              },
              '5' => {
                  'question_text' => 'What is the current value of your Other Real Estate?',
                  'question_name' => 'real_estate_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '300000'
              },
              '6' => {
                  'question_text' => 'What is the mortgage balance on your Other Real Estate?',
                  'question_name' => 'real_estate_mortgage_balance',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '250000'
              },
              '7' => {
                  'question_text' => 'Is there a lean, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?',
                  'question_name' => 'real_estate_second_mortgage',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'yes'
              },
              '8' => {
                  'question_text' => 'What is the current balance of the lean(s)?',
                  'question_name' => 'real_estate_second_mortgage_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '200000'
              },
              '9' => {
                  'question_text' => 'Do you receive income from your Other Real Estate (rent, etc.)?',
                  'question_name' => 'real_estate_rent_income',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'yes'
              },
              '10' => {
                  'question_text' => 'What is the income YOU receive from your Other Real Estate (calculated annually)?',
                  'question_name' => 'real_estate_rent_income_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '15000'
              }
          },
          '1' => {
              '0' => {
                  'question_text' => 'What type of Other Real Estate do you own?',
                  'question_name' => 'real_estate_type',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'Industrial'
              },
              '1' => {
                  'question_text' => 'What is the address of your Other Real Estate?',
                  'question_name' => 'real_estate_address',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '1216 E Baltimore St # 300'
              },
              '2' => {
                  'question_text' => 'Is your Other Real Estate jointly owned?',
                  'question_name' => 'real_estate_jointly_owned',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'no'
              },
              '3' => {
                  'question_text' => 'What percentage of ownership do you have in your Other Real Estate?',
                  'question_name' => 'real_estate_jointly_owned_percent',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => ''
              },
              '4' => {
                  'question_text' => 'What percentage of the mortgage are you responsible for in your Other Real Estate?',
                  'question_name' => 'real_estate_percent_of_mortgage',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '90'
              },
              '5' => {
                  'question_text' => 'What is the current value of your Other Real Estate?',
                  'question_name' => 'real_estate_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '200000'
              },
              '6' => {
                  'question_text' => 'What is the mortgage balance on your Other Real Estate?',
                  'question_name' => 'real_estate_mortgage_balance',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '150000'
              },
              '7' => {
                  'question_text' => 'Is there a lean, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?',
                  'question_name' => 'real_estate_second_mortgage',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'yes'
              },
              '8' => {
                  'question_text' => 'What is the current balance of the lean(s)?',
                  'question_name' => 'real_estate_second_mortgage_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '100000'
              },
              '9' => {
                  'question_text' => 'Do you receive income from your Other Real Estate (rent, etc.)?',
                  'question_name' => 'real_estate_rent_income',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => 'yes'
              },
              '10' => {
                  'question_text' => 'What is the income YOU receive from your Other Real Estate (calculated annually)?',
                  'question_name' => 'real_estate_rent_income_value',
                  'answered_for_type' => '',
                  'answered_for_id' => '',
                  'value' => '30000'
              }
          }
      }

      stub_persisted_app
      @strategy = Strategy::Answer::RealEstate.new(@user, nil, @presentation, nil, @data)
    end

    describe 'set_details' do
      before do
        @strategy.set_details
        @answer = @strategy.answer
      end

      it 'should reformat the data and set the details to a nice array of key-value pairs' do
        expect(@answer.details.first).to include('real_estate_type' => 'Industrial')
        expect(@answer.details.first).to include('real_estate_address' => '121 Madison Ave')
        expect(@answer.details.first).to include('real_estate_jointly_owned' => 'yes')
        expect(@answer.details.first).to include('real_estate_jointly_owned_percent' => '80')
        expect(@answer.details.first).to include('real_estate_percent_of_mortgage' => '50')
        expect(@answer.details.first).to include('real_estate_value' => '300000')
        expect(@answer.details.first).to include('real_estate_mortgage_balance' => '250000')
        expect(@answer.details.first).to include('real_estate_second_mortgage' => 'yes')
        expect(@answer.details.first).to include('real_estate_second_mortgage_value' => '200000')
        expect(@answer.details.first).to include('real_estate_rent_income' => 'yes')
        expect(@answer.details.first).to include('real_estate_rent_income_value' => '15000')
        expect(@answer.details.first).to include('real_estate_second_mortgage_percent' => nil)
        expect(@answer.details.last).to include('real_estate_type' => 'Industrial')
        expect(@answer.details.last).to include('real_estate_address' => '1216 E Baltimore St # 300')
        expect(@answer.details.last).to include('real_estate_jointly_owned' => 'no')
        expect(@answer.details.last).to include('real_estate_jointly_owned_percent'=>nil)
        expect(@answer.details.last).to include('real_estate_percent_of_mortgage' =>nil)
        expect(@answer.details.last).to include('real_estate_value' => '200000')
        expect(@answer.details.last).to include('real_estate_mortgage_balance' => '150000')
        expect(@answer.details.last).to include('real_estate_second_mortgage' => 'yes')
        expect(@answer.details.last).to include('real_estate_second_mortgage_value' => '100000')
        expect(@answer.details.last).to include('real_estate_rent_income' => 'yes')
        expect(@answer.details.last).to include('real_estate_rent_income_value' => '30000')
        expect(@answer.details.last).to include('real_estate_second_mortgage_percent' => nil)
      end

      describe 'set_value' do
        before do
          @strategy.set_value
          @answer = @strategy.answer
        end

        it 'should total the rental income value' do
          expect(@answer.casted_value['income']).to eq(BigDecimal("45000"))
        end

        it 'should total the property value' do
          expect(@answer.casted_value['assets']).to eq(BigDecimal("500000"))
        end

        it 'should total the liabilities' do
          # jointly owned          |  not jointly owned
          # .5 * (250000 + 200000) + (150000 + 100000) # not picking up second part
          # FOR NOW (and for EDWOSB) we DO NOT factor in the percentage ownership
          expect(@answer.casted_value['liabilities']).to eq(BigDecimal("700000"))
        end
      end
    end
  end
end
