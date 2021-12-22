require 'question_type'

class QuestionType::Duns < QuestionType
  def partial
    "question_types/duns"
  end

  def validation_settings
    {
        rules: {
            required: true,
            digits: true,
            minlength: 9,
            maxlength:9,
            validateDuns: true
        },
        messages: {
            required: "Please answer this question",
            minlength: "Please enter 9 digit DUNS number",
            maxlength: "Please enter 9 digit NAICS number"
        }
    }
  end

  def cast(value)
    self.class.cast(value)
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
