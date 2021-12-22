require 'question_type'

class QuestionType::OwnerList < QuestionType
  def partial
    "question_types/owner_list"
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
