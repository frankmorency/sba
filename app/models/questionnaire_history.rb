class QuestionnaireHistory < ActiveRecord::Base
  belongs_to :certificate_type
  belongs_to :questionnaire
end
