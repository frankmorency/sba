class ApplicableQuestion < ActiveRecord::Base
  include QuestionProxy

  acts_as_paranoid
  has_paper_trail

  belongs_to :question
  belongs_to :evaluation_purpose

  attr_accessor :answer

  def evaluate
    raise "Question not answered: #{question.title}" unless answer

    raise "Attempting to answer the wrong question: #{answer.question.name} != #{question.name}" unless answer.question == question

    answer.evaluated_response = question.question_type.evaluate(answer.display_value, positive_response, certificate_type: evaluation_purpose.certificate_type)
  end
end
