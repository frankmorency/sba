class QuestionType::SixQuestionsPercentage < QuestionType

  def partial
    "question_types/six_questions_percentage"
  end

  def cast(value)
    value
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end

end