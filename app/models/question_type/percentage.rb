require 'question_type'

class QuestionType::Percentage < QuestionType
  def partial
    "question_types/percentage"
  end

  def cast(value)
    return 0 unless value
    return value if value.is_a?(BigDecimal)
    BigDecimal(value) * BigDecimal(".01")
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end
