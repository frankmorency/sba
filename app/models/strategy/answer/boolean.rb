module Strategy
  module Answer
    class Boolean < Base
      VALID_ANSWERS = %w(yes no)

      def validate
        unless VALID_ANSWERS.include? value
          @errors << "Boolean answers must be yes or no, not #{value}"
        end
      end
    end
  end
end
