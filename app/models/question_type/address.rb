require 'question_type'

class QuestionType::Address < QuestionType
  def partial
    "question_types/address"
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
