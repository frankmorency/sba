class FinancialSummary
  class Liabilities
    attr_accessor :contributor, :app, :answers, :assets

    def initialize(contributor, app, assets)
      @contributor = contributor
      @assets = assets
      @app = app

      @answers = {
          17 => {
              label: 'Accounts Payable',
              value: contributor.answer_for(:recurring_accounts_payable_amount, app.id).try(:display_value) || BigDecimal(0),
              question_name: 'notes_payable'
          },
          18 => {
              label: 'Notes Payable to Banks & Others',
              value: contributor.answer_for(:notes_payable, app.id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
              question_name: 'notes_payable'
          },
          19 => {
              position: 3,
              label: 'Installment Account (Auto)',
              value: contributor.answer_for(:automobiles, app.id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
              question_name: 'real_estate_primary_residence'
          },
          20 => {
              label: 'Installment Account (Other)',
              value: contributor.answer_for(:other_personal_property, app.id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
              question_name: 'personal_property'
          },
          21 => {
              label: 'Loan(s) Against Life Insurance',
              value: contributor.answer_for(:life_insurance_loan_value, app.id).try(:display_value) || BigDecimal(0),
              question_name: 'life_insurance'
          },
          22 => {
              label: 'Mortgage (Primary Residence)*',
              value: contributor.answer_for(:primary_real_estate, app.id).try(:display_value, 'liabilities') || BigDecimal(0),
              question_name: 'real_estate_primary_residence'
          },
          23 => {
              label: 'Mortgages on other Real Estate',
              value: contributor.answer_for(:other_real_estate, app.id).try(:display_value, 'liabilities') || BigDecimal(0),
              question_name: 'real_estate_other'
          },
          24 => {
              label: 'Unpaid Taxes',
              value: contributor.answer_for(:assessed_taxes, app.id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
              question_name: 'assessed_taxes'
          },
          25 => {
              label: 'Other Liabilities',
              value: contributor.answer_for(:other_liabilities, app.id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
              question_name: 'assessed_taxes'
          }
      }

      @answers[26] = {
          label: 'Total Liabilities',
          class: 'bold',
          value: total
      }

      @answers[27] = {
          label: 'Net Worth<br>Total Assets - Total Liabilities'.html_safe,
          class: 'bold',
          value: assets.total - total
      }
    end

    def total
      @total ||= answers.values.map {|answer| answer[:value]}.compact.map {|n| BigDecimal(n) }.sum
    end
  end
end
