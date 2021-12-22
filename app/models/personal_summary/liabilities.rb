class PersonalSummary
  class Liabilities
    attr_accessor :business_partner, :answers, :assets, :sba_application_id

    def initialize(business_partner, assets, sba_application_id)
      @business_partner = business_partner
      @sba_application_id = sba_application_id
      @assets = assets
      @answers = {
        17 => {
          label: 'Accounts Payable',
          value: business_partner.answer_for(:recurring_accounts_payable_amount, sba_application_id).try(:display_value) || BigDecimal(0),
          question_name: 'notes_payable'
        },
        18 => {
          label: 'Notes Payable to Banks & Others',
          value: business_partner.answer_for(:notes_payable, sba_application_id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
          question_name: 'notes_payable'
        },
        19 => {
          position: 3,
          label: 'Installment Account (Auto)',
          value: business_partner.answer_for(:automobiles, sba_application_id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
          question_name: 'real_estate_primary_residence'
        },
        20 => {
          label: 'Installment Account (Other)',
          value: business_partner.answer_for(:other_personal_property, sba_application_id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
          question_name: 'personal_property'
        },
        21 => {
          label: 'Loan(s) Against Life Insurance',
          value: business_partner.answer_for(:life_insurance_loan_value, sba_application_id).try(:display_value) || BigDecimal(0),
          question_name: 'life_insurance'
        },
        22 => {
          label: 'Mortgage (Primary Residence)*',
          value: business_partner.answer_for(:primary_real_estate, sba_application_id).try(:display_value, 'liabilities') || BigDecimal(0),
          question_name: 'real_estate_primary_residence'
        },
        23 => {
          label: 'Mortgages on other Real Estate',
          value: business_partner.answer_for(:other_real_estate, sba_application_id).try(:display_value, 'liabilities') || BigDecimal(0),
          question_name: 'real_estate_other'
        },
        24 => {
          label: 'Unpaid Taxes',
          value: business_partner.answer_for(:assessed_taxes, sba_application_id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
          question_name: 'assessed_taxes'
        },
        25 => {
          label: 'Other Liabilities',
          value: business_partner.answer_for(:other_liabilities, sba_application_id).try(:value).try(:[], 'liabilities') || BigDecimal(0),
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
