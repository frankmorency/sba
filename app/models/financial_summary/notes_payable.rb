class FinancialSummary
  class NotesPayable < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)
      if present?
        @total = contributor.answer_for(:notes_payable, app.id).value['liabilities']
        @answers = contributor.answer_for(:notes_payable, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:notes_payable, app.id)

      contributor.answer_for(:notes_payable, app.id).value['value'].downcase == 'yes'
    end

    def heading_labels
      ['Type', 'Original Balance', 'Current Balance', 'Payment Amount', 'How Secured or Endorsed / Type of Collateral', 'Name of Noteholder', 'Address of Noteholder']
    end

    def field_labels
      %w(type original_balance current_balance payment_amount collateral_type noteholder noteholder_address)
    end

    def formatting
      {
          'original_balance' => :currency,
          'current_balance' => :currency,
          'payment_amount' => :currency
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
          <td colspan="4">
          </td>
        </tr>
      EOF
    end
  end
end
