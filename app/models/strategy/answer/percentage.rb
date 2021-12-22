module Strategy
  module Answer
    class Percentage < Base
      def value
        return 0 unless answer.display_value
        return answer.display_value if answer.display_value.is_a?(BigDecimal)
        BigDecimal(answer.display_value) * BigDecimal(".01")
      end
    end
  end
end
