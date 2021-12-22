require 'question_type'

class QuestionType::Picklist < QuestionType
  def partial
    "question_types/picklist"
  end

  def evaluate(response, positive_response, options = {})
    (response == positive_response) ? Answer::SUCCESS : Answer::FAILURE
  end
end
