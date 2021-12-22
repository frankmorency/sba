class PersonalSummary
  class AGI
    attr_accessor :business_partner, :answers, :sba_application_id

    def hide_agi?
      @hide_agi
    end

    def initialize(business_partner, has_agi, sba_application_id)
      @business_partner = business_partner
      @sba_application_id = sba_application_id
      if has_agi
        @hide_agi = false

        @answers = {
          1 => {
            label: 'Most Recent Tax Year',
            value: agi_year_1,
            question_name: 'adjuste_gross_income'
          },
          2 => {
            label: 'Year 2',
            value: agi_year_2,
            question_name: 'adjuste_gross_income'
          },
          3 => {
            label: 'Year 3',
            value: agi_year_3,
            question_name: 'adjuste_gross_income'
           }
        }

        @answers[4] = {
          label: 'Total (Avg)',
          value: total / 3,
          class: 'bold'
        }
      else
        @hide_agi = true
      end
    end

    def agi_year_1
      business_partner.answer_for(:agi_year_1, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def agi_year_2
      business_partner.answer_for(:agi_year_2, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def agi_year_3
      business_partner.answer_for(:agi_year_3, sba_application_id).try(:display_value) || BigDecimal(0)
    end

    def total
      @answers.values.map {|a| BigDecimal(a[:value]) }.sum
    end
  end
end
