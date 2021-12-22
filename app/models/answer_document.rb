class AnswerDocument < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :answer
  belongs_to :document
end
