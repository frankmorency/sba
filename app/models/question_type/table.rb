require 'question_type'

class QuestionType::Table < QuestionType
  def partial
    "question_types/table"
  end

  def build_answer(user, app_id, presentation, answered_for, data, answer_params = nil)
    if data[:value] == "yes" and (data[:details] == "" or data[:details] == nil or data[:details] == "null")
      raise 'Error: At least one row is required'
    end

    super
  end

  # TODO: This is added to validate details field for Table QuestionType. There might be better ways to do it.
  def additional_validation_settings(question)
    {
        rules: {
            required: conditional_logic(question)
        },
        messages: {
            required: 'At least one row is required'
        }
    }
  end

  def conditional_logic(question)
    case type
      when "QuestionType::Table"
        ["input[name='#{question.dom_id}']:checked", 'equal_to', 'yes']
    end
  end

end
