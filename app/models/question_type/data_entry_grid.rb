require 'question_type'

class QuestionType::DataEntryGrid < QuestionType

  def partial
    'question_types/data_entry_grid'
  end

  def evaluate(response, positive_response, options = {})
    cast(response) == Answer::SUCCESS
  end

  def create_header
    self.config_options
  end

end