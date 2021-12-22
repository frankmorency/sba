module Strategy
  module Answer
    class TextField < Base

      def validate

        single_min = QuestionType::TextField::DEFAULT_SINGLE_LINE_MIN_CHARACTERS_ALLOWED
        single_max = QuestionType::TextField::DEFAULT_SINGLE_LINE_MAX_CHARACTERS_ALLOWED
        multi_min = QuestionType::TextField::DEFAULT_MULTILINE_MIN_CHARACTERS_ALLOWED

        if question_type.is_single?
          @errors << "Single line textfield answers have a minimum character length of #{single_min}" if value.length < single_min
          @errors << "Single line textfield answers have a maximum character length of #{single_max}" if value.strip.gsub("\r\n", "\n").length > single_max
        else
          @errors << "Multiline textfield answers have a minimum character length of #{multi_min}" if value.length < multi_min
        end
      end

      def question_type
        @presentation.question.question_type
      end
    end
  end
end