module Strategy
  module Answer
    class NaicsCode < Base
      def validate
        unless value.is_a?(String) && value.length == 6
          @errors << "The NAICS code must be 6 digits, not #{value}"
        end
      end
    end
  end
end
