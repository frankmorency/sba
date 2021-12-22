require 'question_type'

class QuestionType::Checkbox < QuestionType
  def partial
    "question_types/checkbox"
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end