require 'questionnaire'

class Questionnaire::MasterQuestionnaire < Questionnaire
  def main_section
    first_section
  end
end