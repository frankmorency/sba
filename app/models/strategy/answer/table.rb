module Strategy
  module Answer
    class Table < Base
      def set_details
        @answer = super

        if data[:value] == "yes"
          @answer.details = data[:details]
        else
          @answer.details = nil
        end
      end
    end
  end
end
