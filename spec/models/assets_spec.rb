# require 'rails_helper'
# require 'personal_summary/assets'

# class FakeRealEstate
#   def initialize(n)
#     @n = n
#   end

#   def display_value(v)
#     @n
#   end
# end

# DV_TRANSFORM = -> (n) { Struct.new(:display_value).new(BigDecimal(n)) }
# H_TRANSFORM = -> (k, v) { Struct.new(:value).new({k => v}) }
# O_TRANSFORM = -> (n) { FakeRealEstate.new(n) }


# RSpec.describe PersonalSummary::Assets, type: :model do
#   before do
#     @vendor_in_philly = create_user_vendor_admin
#     @app = create_stubbed_8a_app_with_active_cert(@vendor_in_philly)
#     @business_partner = BusinessPartner.new
#     @business_partner.instance_eval do
#       def answer_for(q, app_id)

#         {
#             stocks_bonds: H_TRANSFORM.call('assets', 200),
#             roth_ira: H_TRANSFORM.call('assets', 201),
#             other_retirement_accounts: H_TRANSFORM.call('assets', 202),
#             other_personal_property: H_TRANSFORM.call('assets', 80),
#             automobiles: H_TRANSFORM.call('assets', 81),
#             life_insurance_cash_surrender: H_TRANSFORM.call('assets', 82),
#             notes_receivable: H_TRANSFORM.call('assets', 83),
#             other_real_estate: O_TRANSFORM.call(51),
#             primary_real_estate: O_TRANSFORM.call(50),
#             edwosb_equity_in_other_firms: DV_TRANSFORM.call(100),
#             edwosb_biz_equity: DV_TRANSFORM.call(101),
#             edwosb_checking_balance: DV_TRANSFORM.call(102),
#             edwosb_savings_balance: DV_TRANSFORM.call(103),
#             edwosb_cash_on_hand: DV_TRANSFORM.call(104)
#         }[q]
#       end
#     end

#     @business_partner

#     @assets = ::PersonalSummary::Assets.new(@business_partner, @app.id)
#     @answers = @assets.answers
#   end

#   describe "answers (table spaced out for display)" do
#     it 'should set all the values based on the answer for' do
#       expect(@answers[1][:label]).to eq('Cash on Hand')
#       expect(@answers[1][:value]).to eq(BigDecimal(104))
#       expect(@answers[2][:label]).to eq('Savings Account(s) Balances')
#       expect(@answers[2][:value]).to eq(BigDecimal(103))
#       expect(@answers[3][:label]).to eq('Checking Account(s) Balances')
#       expect(@answers[3][:value]).to eq(BigDecimal(102))
#       expect(@answers[4][:label]).to eq('Accounts & Notes Receivable')
#       expect(@answers[4][:value]).to eq(BigDecimal(83))
#       expect(@answers[5][:label]).to eq('IRA, 401K or Other Retirement Account')
#       expect(@answers[5][:value]).to eq(BigDecimal(202))
#       expect(@answers[6][:label]).to eq('Roth IRA')
#       expect(@answers[6][:value]).to eq(BigDecimal(201))
#       expect(@answers[7][:label]).to eq('Cash Surrender Value of Whole Life Insurance')
#       expect(@answers[7][:value]).to eq(BigDecimal(82))
#       expect(@answers[8][:label]).to eq('Stocks and Bonds or Mutual Funds')
#       expect(@answers[8][:value]).to eq(BigDecimal(200))
#       expect(@answers[9][:label]).to eq('Real Estate (Primary Residence)')
#       expect(@answers[9][:value]).to eq(BigDecimal(50))
#       expect(@answers[10][:label]).to eq('Other Real Estate')
#       expect(@answers[10][:value]).to eq(BigDecimal(51))
#       expect(@answers[11][:label]).to eq('Automobiles')
#       expect(@answers[11][:value]).to eq(BigDecimal(81))
#       expect(@answers[12][:label]).to eq('Other Personal Property/Assets')
#       expect(@answers[12][:value]).to eq(BigDecimal(80))
#       expect(@answers[14][:label]).to eq("Applicant's Business Equity")
#       expect(@answers[14][:value]).to eq(BigDecimal(101))
#       expect(@answers[15][:label]).to eq("Applicant's Equity in Other Firms")
#       expect(@answers[15][:value]).to eq(BigDecimal(100))
#     end

#     it 'should set the overall total' do
#       expect(@answers[17][:label]).to eq('Total Assets')
#       expect(@answers[17][:value]).to eq(BigDecimal(1540))
#     end
#   end

#   describe PersonalSummary::Liabilities, type: :model do
#     before do
#       @business_partner = BusinessPartner.new
#       @business_partner.instance_eval do
#         def answer_for(q, app_id)
#           {
#               recurring_accounts_payable_amount: DV_TRANSFORM.call(52),
#               notes_payable: H_TRANSFORM.call('liabilities', 303),
#               automobiles: H_TRANSFORM.call('liabilities', 501),
#               life_insurance_loan_value: DV_TRANSFORM.call(23),
#               primary_real_estate: O_TRANSFORM.call(88),
#               other_real_estate: O_TRANSFORM.call(99),
#               assessed_taxes: H_TRANSFORM.call('liabilities', 44),
#               other_liabilities: H_TRANSFORM.call('liabilities', 35),
#               other_personal_property: H_TRANSFORM.call('liabilities', 1)
#           }[q]
#         end
#       end

#       @business_partner

#       @answers = ::PersonalSummary::Liabilities.new(@business_partner, @assets, @app.id).answers
#     end

#     describe "answers (table spaced out for display)" do
#       it 'should set all the values based on the answer for' do
#         expect(@answers[17][:label]).to eq('Accounts Payable')
#         expect(@answers[17][:value]).to eq(BigDecimal(52))
#         expect(@answers[18][:label]).to eq('Notes Payable to Banks & Others')
#         expect(@answers[18][:value]).to eq(BigDecimal(303))
#         expect(@answers[19][:label]).to eq('Installment Account (Auto)')
#         expect(@answers[19][:value]).to eq(BigDecimal(501))
#         expect(@answers[20][:label]).to eq('Installment Account (Other)')
#         expect(@answers[20][:value]).to eq(BigDecimal(1))
#         expect(@answers[21][:label]).to eq('Loan(s) Against Life Insurance')
#         expect(@answers[21][:value]).to eq(BigDecimal(23))
#         expect(@answers[22][:label]).to eq('Mortgage (Primary Residence)*')
#         expect(@answers[22][:value]).to eq(BigDecimal(88))
#         expect(@answers[23][:label]).to eq('Mortgages on other Real Estate')
#         expect(@answers[23][:value]).to eq(BigDecimal(99))
#         expect(@answers[24][:label]).to eq('Unpaid Taxes')
#         expect(@answers[24][:value]).to eq(BigDecimal(44))
#         expect(@answers[25][:label]).to eq('Other Liabilities')
#         expect(@answers[25][:value]).to eq(BigDecimal(35))
#       end

#       it 'should set the overall total2' do
#         expect(@answers[26][:label]).to eq('Total Liabilities')
#         expect(@answers[26][:value]).to eq(BigDecimal(1146))
#         expect(@answers[27][:label]).to eq('Net Worth<br>Total Assets - Total Liabilities')
#         expect(@answers[27][:value]).to eq(BigDecimal(394))
#       end
#     end
#   end
# end


# RSpec.describe PersonalSummary::Income, type: :model do
#   before do
#     @vendor_in_philly = create_user_vendor_admin
#     @app = create_stubbed_8a_app_with_active_cert(@vendor_in_philly)
#     @business_partner = BusinessPartner.new
#     @business_partner.instance_eval do
#       def answer_for(q, app_id)
#         {
#             edwosb_other_income_comment: DV_TRANSFORM.call(500),
#             edwosb_salary: DV_TRANSFORM.call(300000),
#             stocks_bonds: H_TRANSFORM.call('income', 2500),
#             primary_real_estate: O_TRANSFORM.call(1400),
#             other_real_estate: O_TRANSFORM.call(80)

#         }[q]
#       end
#     end

#     @business_partner

#     @answers = ::PersonalSummary::Income.new(@business_partner, @app.id).answers
#   end

#   describe "answers (table spaced out for display)" do
#     it 'should set all the values based on the answer for' do
#       expect(@answers[1][:label]).to eq('Salary')
#       expect(@answers[1][:value]).to eq(BigDecimal(300000))
#       expect(@answers[2][:label]).to eq('Investment Income')
#       expect(@answers[2][:value]).to eq(BigDecimal(2500))
#       expect(@answers[3][:label]).to eq('Real Estate Income')
#       expect(@answers[3][:value]).to eq(BigDecimal(1480))
#       expect(@answers[4][:label]).to eq('Other Income')
#       expect(@answers[4][:value]).to eq(BigDecimal(500))
#     end
#   end
# end


# RSpec.describe PersonalSummary::AGI, type: :model do
#   before do
#     @vendor_in_philly = create_user_vendor_admin
#     @app = create_stubbed_8a_app_with_active_cert(@vendor_in_philly)
#     @business_partner = BusinessPartner.new
#     @business_partner.instance_eval do
#       def answer_for(q, app_id)
#         {
#             agi_year_3: DV_TRANSFORM.call(100000),
#             agi_year_2: DV_TRANSFORM.call(200000),
#             agi_year_1: DV_TRANSFORM.call(300000)
#         }[q]
#       end
#     end

#     @business_partner

#     @answers = ::PersonalSummary::AGI.new(@business_partner, true, @app.id).answers
#   end

#   describe "answers (table spaced out for display)" do
#     it 'should set all the values based on the answer for' do
#       expect(@answers[1][:label]).to eq('Most Recent Tax Year')
#       expect(@answers[1][:value]).to eq(BigDecimal(300000))
#       expect(@answers[2][:label]).to eq('Year 2')
#       expect(@answers[2][:value]).to eq(BigDecimal(200000))
#       expect(@answers[3][:label]).to eq('Year 3')
#       expect(@answers[3][:value]).to eq(BigDecimal(100000))
#     end

#     it 'should set the overall total' do
#       expect(@answers[4][:label]).to eq('Total (Avg)')
#       expect(@answers[4][:value]).to eq(BigDecimal(200000))
#     end
#   end
# end
