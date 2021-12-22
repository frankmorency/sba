require 'question_type'

class QuestionType::Null < QuestionType
  def partial
    "question_types/null"
  end

  def cast(value)
    nil
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
