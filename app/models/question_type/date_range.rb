require 'question_type'

class QuestionType::DateRange < QuestionType

  def partial
    'question_types/date_range'
  end

  def validation_settings
    {
      rules: {
        required: true,
        dateFormatValidation: true,
        validateDateRange: 'The FROM date must be on or before the TO date'
      },
      messages: {
        required: 'Please answer this question'
      }
    }
  end

  def evaluate(response, positive_response, options = {})    
    cast(response) == Answer::SUCCESS
  end

end