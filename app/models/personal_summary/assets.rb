class PersonalSummary
  class Assets
    attr_accessor :business_partner, :answers, :sba_application_id

    def initialize(business_partner, sba_application_id)
      @business_partner = business_partner
      @sba_application_id = sba_application_id
      @answers = {
        1 => {
          label: 'Cash on Hand',
          value: cash_on_hand,
          question_name: 'cash_on_hand'
        },
        2 => {
          label: 'Savings Account(s) Balances',
          value: savings_balance,
          question_name: 'cash_on_hand'
        },
        3 => {
          label: 'Checking Account(s) Balances',
          value: checking_balance,
          question_name: 'cash_on_hand'
        },
        4 => {
          label: 'Accounts & Notes Receivable',
          value: notes_receivable,
          question_name: 'notes_receivable'
        },
        5 => {
          label: 'IRA, 401K or Other Retirement Account',
          value: other_retirement_accounts,
          question_name: 'retirement_accounts'
        },
        6 => {
          label: 'Roth IRA',
          value: roth_ira,
          question_name: 'retirement_accounts'
        },
        7 => {
          label: 'Cash Surrender Value of Whole Life Insurance',
          value: life_insurance_surrender_value,
          question_name: 'life_insurance'
        },
        8 => {
          label: 'Stocks and Bonds or Mutual Funds',
          value: stock_bonds,
          question_name: 'stocks_bonds'
        },
        9 => {
          label: 'Real Estate (Primary Residence)',
          value: primary_real_estate,
          question_name: 'real_estate_primary_residence'
        },
        10 => {
          label: 'Other Real Estate',
          value: other_real_estate,
          question_name: 'real_estate_other'
        },
        11 => {
          label: 'Automobiles',
          value: automobiles,
          question_name: 'personal_property'
        },
        12 => {
          label: 'Other Personal Property/Assets',
          value: other_personal_property,
          question_name: 'personal_property'
        },
        14 => {
          label: "Applicant's Business Equity",
          value: biz_equity,
          question_name: 'other_sources_of_income'
        },
        15 => {
          label: "Applicant's Equity in Other Firms",
          value: equity_in_other_firms,
          question_name: 'other_sources_of_income'
        }
      }

      @answers[17] = {
        label: 'Total Assets',
        class: 'bold',
        value: total
      }

    end

    def equity_in_other_firms
      business_partner.answer_for(:edwosb_equity_in_other_firms, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def biz_equity
      business_partner.answer_for(:edwosb_biz_equity, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def other_personal_property
      business_partner.answer_for(:other_personal_property, sba_application_id).try(:value).try(:[], 'assets')
    end

    def automobiles
      business_partner.answer_for(:automobiles, sba_application_id).try(:value).try(:[], 'assets')
    end

    def other_real_estate
      business_partner.answer_for(:other_real_estate, sba_application_id).try(:display_value, 'assets') || BigDecimal(0)
    end

    def primary_real_estate
      business_partner.answer_for(:primary_real_estate, sba_application_id).try(:display_value, 'assets') || BigDecimal(0)
    end

    def stock_bonds
      business_partner.answer_for(:stocks_bonds, sba_application_id).try(:value).try(:[], 'assets')
    end

    def roth_ira
      business_partner.answer_for(:roth_ira, sba_application_id).try(:value).try(:[], 'assets')
    end

    def other_retirement_accounts
      business_partner.answer_for(:other_retirement_accounts, sba_application_id).try(:value).try(:[], 'assets')
    end

    def life_insurance_surrender_value
      business_partner.answer_for(:life_insurance_cash_surrender, sba_application_id).try(:value).try(:[], 'assets')
    end

    def notes_receivable
      business_partner.answer_for(:notes_receivable, sba_application_id).try(:value).try(:[], 'assets')
    end

    def checking_balance
      business_partner.answer_for(:edwosb_checking_balance, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def savings_balance
      business_partner.answer_for(:edwosb_savings_balance, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def cash_on_hand
      business_partner.answer_for(:edwosb_cash_on_hand, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def total
      @total ||= answers.values.map {|answer| answer[:value]}.compact.map {|n| BigDecimal(n) }.sum
    end
  end
end
