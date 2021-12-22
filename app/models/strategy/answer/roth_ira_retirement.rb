module Strategy
  module Answer
    class RothIRARetirement < Table
      def set_value
        @answer = super
        if @answer.details.blank?
          @answer.value["assets"] = "0"
        else
          @answer.value["assets"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['total_value'].to_s) }
        end
      end
    end
  end
end
