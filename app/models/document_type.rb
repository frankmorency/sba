class DocumentType < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :documents
  has_many :document_type_questions
  has_many :questions, through: :document_type_questions
end
