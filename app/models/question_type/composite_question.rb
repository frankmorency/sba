class QuestionType::CompositeQuestion < QuestionType
  # this is the view you will use for rendering the question

  def partial
    "question_types/composite_question"
  end

  def cast(value)
    # do real work here
    value
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end
end