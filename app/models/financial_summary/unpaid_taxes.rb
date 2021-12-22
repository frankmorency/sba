class FinancialSummary
  class UnpaidTaxes < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)

      if present?
        @total = contributor.answer_for(:assessed_taxes, app.id).value['liabilities']
        @answers = contributor.answer_for(:assessed_taxes, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:assessed_taxes, app.id)

      contributor.answer_for(:assessed_taxes, app.id).value['value'].downcase == 'yes'
    end

    def heading_labels
      ['Whom Payable', 'Amount', 'When Due', 'Property (if any) a tax lien attaches']
    end

    def field_labels
      %w(whom_payable amount when_due property_tax_lien)
    end

    def formatting
      {
          'amount' => :currency,
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
          <td colspan="2">
          </td>
        </tr>
      EOF
    end
  end
end
