require 'question_type'

class QuestionType::Boolean < QuestionType
  def partial
    "question_types/boolean"
  end

  def cast(value)
    value == 'yes' ? true : false
  end

  def evaluate(response, positive_response, options = {})
    (response == positive_response) ? Answer::SUCCESS : Answer::FAILURE
  end
end
