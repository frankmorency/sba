class DocumentTypeQuestion < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :document_type
  belongs_to :question
end
