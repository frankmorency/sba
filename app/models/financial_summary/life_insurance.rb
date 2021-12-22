class FinancialSummary
  class LifeInsurance < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)

      if present?
        @total = contributor.answer_for(:life_insurance_cash_surrender, app.id).value['assets']
        @answers = contributor.answer_for(:life_insurance_cash_surrender, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:life_insurance_cash_surrender, app.id)

      contributor.answer_for(:life_insurance_cash_surrender, app.id).value['value'].downcase == 'yes'
    end

    def heading_labels
      ['Name of Insurance Company', 'Cash Surrender Value (if applicable)', 'Face Amount', 'Beneficiaries']
    end

    def field_labels
      %w(company_name cash_surrender_value face_amount beneficiaries)
    end

    def formatting
      {
          'cash_surrender_value' => :currency,
          'face_amount' => :currency
      }
    end

    def total_row
      return <<-EOF
        <tr>
          <td>
            <b>Total</b>
          </td>
          <td>
            #{helper.number_to_currency(total) if total}
          </td>
          <td>
          </td>
          <td>
          </td>
        </tr>
      EOF
    end
  end
end
