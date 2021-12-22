module Strategy
  module Answer
    class PersonalProperty < Table
      def set_value
        @answer = super
        if @answer.details.blank?
          @answer.value["assets"] = "0"
          @answer.value["liabilities"] = "0"
          @answer.value["total_payment_amount"] = "0"
        else
          @answer.value["assets"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['current_value'].to_s) }
          @answer.value["liabilities"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['loan_balance'].to_s) }
          @answer.value["total_payment_amount"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['current_value'].to_s) }
        end
      end
    end
  end
end
