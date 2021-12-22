require 'question_type'

class QuestionType::RealEstate < QuestionType
  def partial
    "question_types/real_estate"
  end

  def cast(value)
    cv = {}
    cv['assets'] = QuestionType::Currency.cast value['assets']
    cv['liabilities'] = QuestionType::Currency.cast value['liabilities']
    cv['income'] = QuestionType::Currency.cast value['income']
    cv
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
