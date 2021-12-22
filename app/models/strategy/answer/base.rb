module Strategy
  module Answer
    class Base
      attr_accessor :user, :presentation, :answered_for, :data, :answer, :errors, :sba_application

      def initialize(user, app_id, presentation, answered_for, data)
        @user, @presentation, @answered_for, @data = user, presentation, answered_for, data

        @sba_application = SbaApplication.find(app_id)

        @errors = []
      end

      def value
        @answer.value['value']
      end

      def validate
      end

      def valid?
        validate
        @errors.empty?
      end

      def set_details
        @answer = user.answers.for_application(@sba_application, presentation, answered_for)

        unless @answer
          @answer = user.answers.new
        end

        @answer.sba_application_id = @sba_application.id
        @answer.question_id = presentation.unique_id
        @answer.answered_for = answered_for
        @answer.comment = data[:comment]
        @answer.question_text = data[:question_text]
        @answer.explanations = { failure: presentation.failure_message,
                                maybe: presentation.maybe_message }
        @answer.brand_new_answered_for_ids = []

        @answer
      end

      def app_id
        @sba_application.id
      end

      def set_value
        @answer.value = {value: data[:value]}
        @answer
      end

      def to_error
        ValidationError.new(self)
        #Error.new(self)
      end
    end
  end
end
