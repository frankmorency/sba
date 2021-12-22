module Strategy
  module Answer
    class CompositeQuestion < Base
      attr_accessor :sub_questions

      def set_details
        @details_casted = []

        @answer = super
        @sub_questions = @answer.question.sub_questions
        
        if data[:sub_questions].present?
          @answer.details = data[:sub_questions]
        else
          @answer.details = []
        end

        data.values.select {|v| v.is_a?(Hash) }.map {|h| h.values }.each do |fields|
          @answer.details << {}
          fields.each do |field|
            next unless field['question_name']
            @answer.details.last[field['question_name']] = field['value']
          end
        end

        validate_data

        @answer
      end

      private

      def validate_data
        @answer.details.each_with_index do |re|
          @details_casted << {}

          @sub_questions.each do |sub_question|
            strategy = sub_question.to_strategy(user, app_id, answered_for, re[sub_question.name])
            re[sub_question.name] = strategy.answer.display_value
            @details_casted.last[sub_question.name] = strategy.answer.casted_value
            raise strategy.to_error unless strategy.valid?
          end
        end
      end

    end
  end
end
