require 'question_type'

class QuestionType::FullAddress < QuestionType
  def partial
    "question_types/full_address"
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end