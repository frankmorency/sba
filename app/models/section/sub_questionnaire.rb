require_relative '../section'

class Section::SubQuestionnaire < Section
  belongs_to  :sub_questionnaire, class_name: 'Questionnaire::SubQuestionnaire'
  belongs_to  :sub_application, class_name: 'SbaApplication::SubApplication'

  before_create :set_sub_q_status
end