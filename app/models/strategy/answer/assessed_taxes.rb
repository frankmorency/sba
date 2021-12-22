module Strategy
  module Answer
    class AssessedTaxes < Table
      def set_value
        @answer = super
        if @answer.details.blank?
          @answer.value["liabilities"] = "0"
        else
          @answer.value["liabilities"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['amount'].to_s) }
        end
      end
    end
  end
end
