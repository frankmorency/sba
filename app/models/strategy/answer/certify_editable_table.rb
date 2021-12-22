module Strategy
  module Answer
    class CertifyEditableTable < Base
      def set_details
        @answer = super
        @answer.details = data[:details]
      end
    end
  end
end