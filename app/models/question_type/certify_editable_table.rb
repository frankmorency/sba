require 'question_type'

class QuestionType::CertifyEditableTable < QuestionType

  def partial
    'question_types/certify_editable_table'
  end

  def evaluate(response, positive_response, options = {})
    cast(response) == Answer::SUCCESS
  end
end