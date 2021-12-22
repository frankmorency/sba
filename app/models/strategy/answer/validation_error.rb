module Strategy
  module Answer
    class ValidationError < ::StandardError
      attr_accessor :strategy

      def initialize(message = nil)
        @strategy = message
      end

      def message
        "Strategy::Answer::ValidationError: #{strategy.errors}\n#{strategy.data}"
      end
    end
  end
end
