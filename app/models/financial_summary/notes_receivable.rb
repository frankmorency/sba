class FinancialSummary
  class NotesReceivable < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)

      if present?
        @total = contributor.answer_for(:notes_receivable, app.id).value['assets']
        @answers = contributor.answer_for(:notes_receivable, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:notes_receivable, app.id)

      contributor.answer_for(:notes_receivable, app.id).value['value'].downcase == 'yes'
    end

    def heading_labels
      ['Name of Debtor', 'Address of Debtor', 'Original Balance', 'Current Balance', 'Payment Amount (Calculated Annually)', 'How Secured or Endorsed / Type of Collateral']
    end

    def field_labels
      %w(debtor_name debtor_address original_balance current_balance pay_amount collateral_type)
    end

    def formatting
      {
          'original_balance' => :currency,
          'current_balance' => :currency,
          'pay_amount' => :currency
      }
    end

    def total_row
      return <<-EOF
        <tr>
          <td colspan="2">
            <b>Total</b>
          </td>
          <td>
            #{helper.number_to_currency(total) if total}
          </td>
          <td colspan="3">
          </td>
        </tr>
      EOF
    end
  end
end
