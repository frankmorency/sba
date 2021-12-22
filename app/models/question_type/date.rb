require 'question_type'
require 'date'

class QuestionType::Date < QuestionType
  def partial
    "question_types/date"
  end

  def validation_settings
    {
      rules: {
        required: true,
        dateFormatValidation: true
      },
      messages: {
        required: "Please answer this question"
      }
    }
  end

  def cast(value)
    if value.nil? || value.is_a?(Date)
      value
    else
      if value =~ /^\s*(\d+)\/(\d+)\/(\d+)\s*$/
        value = "#{$2}/#{$3}/#{$1}" # cause matz hates american date format?
      end
      ::Date.parse(value)
    end
  end

  def evaluate(response, positive_response, options = {})
    begin
      @date = DateTime.parse(response)
      Answer::SUCCESS
    rescue
      Answer::FAILURE
    end
  end
end
