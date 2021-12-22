require 'question_type'

class QuestionType::NaicsCode < QuestionType
  def partial
    "question_types/naics_code"
  end

  def validation_settings
    {
        rules: {
            required: true
        },
        messages: {
            required: "Please answer this question"
        }
    }
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
