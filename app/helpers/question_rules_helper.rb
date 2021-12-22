module QuestionRulesHelper

  def answers_for_question(user, sba_application, question_presentation, answered_for)
    if question_presentation.prepopulate
      question_presentation.answers.where(answered_for: answered_for, owner: user).order(created_at: :desc).limit(1).first
    else
      user.answers.for_application(sba_application, question_presentation, answered_for)
    end
  end

end