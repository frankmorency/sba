require 'question_type'

class QuestionType::YesNoNa < QuestionType
  def partial
    "question_types/yes_no_na"
  end

  def cast(value)
    case value
      when 'yes'
        Answer::SUCCESS
      when 'no'
        Answer::FAILURE
      else
        Answer::MAYBE
    end
  end

  def evaluate(response, positive_response, options = {})
    cast(response)
  end
end
