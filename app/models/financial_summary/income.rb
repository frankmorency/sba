class FinancialSummary
  class Income
    attr_accessor :contributor, :app, :answers

    def initialize(contributor, app)
      @contributor = contributor
      @app = app

      @answers = {
          1 => {
              label: 'Salary',
              value: salary,
              question_name: 'other_sources_of_income'
          },
          2 => {
              label: 'Investment Income',
              value: stocks_bonds,
              question_name: 'stocks_bonds'
          },
          3 => {
              label: 'Real Estate Income',
              value: rental_income,
              question_name: 'real_estate_other'
          },
          4 => {
              label: 'Other Income',
              value: other_income,
              question_name: 'other_sources_of_income'
          }
      }
    end

    def other_income
      # Question Name changed in APP-538 https://github.com/USSBA/sba-app/blob/develop/db/migrate/20170317190710_loading_edwosb_v2.rb
      contributor.answer_for(:edwosb_other_income_comment, app.id).try(:display_value) || BigDecimal(0)
    end

    def salary
      contributor.answer_for(:edwosb_salary, app.id).try(:display_value) || BigDecimal(0)
    end

    def stocks_bonds
      contributor.answer_for(:stocks_bonds, app.id).try(:value).try(:[], 'income') || BigDecimal(0)
    end

    def rental_income
      BigDecimal(contributor.answer_for(:primary_real_estate, app.id).try(:display_value, 'income') || 0) +
          BigDecimal(contributor.answer_for(:other_real_estate, app.id).try(:display_value, 'income') || 0)
    end
  end
end
