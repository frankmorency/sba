module Strategy
  module Answer
    class StocksAndBonds < Table
      def set_value
        @answer = super
        if @answer.details.blank?
          @answer.value["assets"] = "0"
          @answer.value["total_cost"] = "0"
          @answer.value["total_market_value"] = "0"
          @answer.value["income"] = "0"
        else
          @answer.value["assets"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['total_value'].to_s) }
          @answer.value["total_cost"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['cost'].to_s) }
          @answer.value["total_market_value"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['market_value'].to_s) }
          @answer.value["income"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['interest_dividends'].to_s) }
        end
      end
    end
  end
end
