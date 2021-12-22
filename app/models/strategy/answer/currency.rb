module Strategy
  module Answer
    class Currency < Base

      def validate
        unless is_number?(value) || value.nil?
          @errors << "Currency answers must be numbers"
        end
      end

      def set_value
        super
        if data[:value] == ''
          @answer.value = {value: "0.0"}
        end
        @answer
      end

      def is_number? string
        true if Float(string) rescue false
      end

    end
  end
end
