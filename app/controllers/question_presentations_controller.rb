# this should be in the SBA Application controller now

#/app/question_type/question_presentations

class QuestionPresentationsController < ApplicationController
  before_action  :set_application
  before_action  :set_section
  before_action  :set_question
  before_action  :authenticate_user!

  def new # need answered for
    @question = @section.question_presentations.find_by(question_id: @question.id)
    @index = params[:index]
    @question.details = @question.sub_questions.map {|q| { q.name => nil } }
    @real_estate_type = question_id

    render layout: false
  end

  private

  def set_question
    @question = Question.find_by(name: question_id)
  end

  def question_id
    params.require(:question_id)
  end
end
