class FinancialSummary
  class Assets
    attr_accessor :contributor, :answers, :app

    def initialize(contributor, app)
      @contributor = contributor
      @app = app

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
      contributor.answer_for(:edwosb_equity_in_other_firms, app.id).try(:display_value) || BigDecimal(0)
    end

    def biz_equity
      contributor.answer_for(:edwosb_biz_equity, app.id).try(:display_value) || BigDecimal(0)
    end

    def other_personal_property
      contributor.answer_for(:other_personal_property, app.id).try(:value).try(:[], 'assets')
    end

    def automobiles
      contributor.answer_for(:automobiles, app.id).try(:value).try(:[], 'assets')
    end

    def other_real_estate
      contributor.answer_for(:other_real_estate, app.id).try(:display_value, 'assets') || BigDecimal(0)
    end

    def primary_real_estate
      contributor.answer_for(:primary_real_estate, app.id).try(:display_value, 'assets') || BigDecimal(0)
    end

    def stock_bonds
      contributor.answer_for(:stocks_bonds, app.id).try(:value).try(:[], 'assets')
    end

    def roth_ira
      contributor.answer_for(:roth_ira, app.id).try(:value).try(:[], 'assets')
    end

    def other_retirement_accounts
      contributor.answer_for(:other_retirement_accounts, app.id).try(:value).try(:[], 'assets') || BigDecimal(0)
    end

    def life_insurance_surrender_value
      contributor.answer_for(:life_insurance_cash_surrender, app.id).try(:value).try(:[], 'assets')
    end

    def notes_receivable
      contributor.answer_for(:notes_receivable, app.id).try(:value).try(:[], 'assets')
    end

    def checking_balance
      contributor.answer_for(:edwosb_checking_balance, app.id).try(:display_value) || BigDecimal(0)
    end

    def savings_balance
      contributor.answer_for(:edwosb_savings_balance, app.id).try(:display_value) || BigDecimal(0)
    end

    def cash_on_hand
      contributor.answer_for(:edwosb_cash_on_hand, app.id).try(:display_value) || BigDecimal(0)
    end

    def total
      @total ||= answers.values.map {|answer| answer[:value]}.compact.map {|n| BigDecimal(n) }.sum
    end
  end
end
