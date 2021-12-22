class FinancialSummary
  class StocksBonds < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)

      if present?
        @total = [
          contributor.answer_for(:stocks_bonds, app.id).value['assets'],
          contributor.answer_for(:stocks_bonds, app.id).value['total_cost'],
          contributor.answer_for(:stocks_bonds, app.id).value['total_market_value']
        ]
        @answers = contributor.answer_for(:stocks_bonds, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:stocks_bonds, app.id)

      contributor.answer_for(:stocks_bonds, app.id).value['value'].downcase == 'yes'
    end

    def heading_labels
      ['Type', 'Name of Security', 'Total Value', 'Number of Shares', 'Cost', 'Market Value Quotation / Exchange', 'Date of Quotation / Exchange']
    end

    def field_labels
      %w(type securities_name total_value num_of_shares cost market_value date)
    end

    def formatting
      {
          'total_value' => :currency,
          'cost' => :currency,
          'market_value' => :currency
      }
    end

    def total_row
      return <<-EOF
        <tr>
          <td></td>
          <td>
            <b>Total</b>
          </td>
          <td>
            #{helper.number_to_currency(total[0]) if total[0]}
          </td>
          <td></td>
          <td>
            #{helper.number_to_currency(total[1]) if total[1]}
          </td>
          <td>
            #{helper.number_to_currency(total[2]) if total[2]}
          </td>
          <td>
          </td>
        </tr>
      EOF
    end
  end
end
