require 'questionnaire/master_questionnaire'

class Questionnaire::AdverseActionBlank < Questionnaire::MasterQuestionnaire
  def start_application(org, options = {})
    SbaApplication::AdverseActionBlank.new(options.merge(organization: org, questionnaire: self, prerequisite_order: prerequisite_order, certificate: org.certificates.eight_a.first))
  end
end