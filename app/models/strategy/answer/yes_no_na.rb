module Strategy
  module Answer
    class YesNoNa < Base
      VALID_ANSWERS = %w(yes no na)

      def validate
        unless VALID_ANSWERS.include? value
          @errors << "Boolean answers must be yes/no/na, not #{value}"
        end
      end
    end
  end
end
