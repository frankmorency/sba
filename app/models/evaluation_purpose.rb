class EvaluationPurpose < ActiveRecord::Base
  include NameRequirements

  acts_as_paranoid
  has_paper_trail

  belongs_to :certificate_type
  belongs_to :questionnaire
  has_many :applicable_questions

  attr_accessor :explanations
end
