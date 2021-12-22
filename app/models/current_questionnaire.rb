class CurrentQuestionnaire < ActiveRecord::Base
  belongs_to :certificate_type
  belongs_to :questionnaire

  validates :kind, inclusion: {in: SbaApplication::KINDS}

end
