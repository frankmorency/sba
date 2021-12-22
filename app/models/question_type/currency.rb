require 'question_type'

class QuestionType::Currency < QuestionType
  def self.cast(value)
    return 0 unless value
    return value if value.is_a?(BigDecimal)
    BigDecimal(value)
  end

  def partial
    "question_types/currency"
  end

  def cast(value)
    self.class.cast(value)
  end

  def evaluate(response, positive_response, options = {})
    begin
      # TODO: Replace with BigDecimal...
      f = Float(response)
      #f.round(2)
      #response = f.to_s
      Answer::SUCCESS
    rescue
      Answer::FAILURE
    end
  end
end
