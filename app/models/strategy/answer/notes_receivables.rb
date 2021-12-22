module Strategy
  module Answer
    class NotesReceivables < Table
      def set_value
        @answer = super
        if @answer.details.blank?
          @answer.value["assets"] = "0"
        else
          @answer.value["assets"] = JSON.parse(data[:details]).sum { |key, value| BigDecimal(value['original_balance'].to_s) }
        end
      end
    end
  end
end
