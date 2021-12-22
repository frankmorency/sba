require 'questionnaire/master_questionnaire'

class Questionnaire::EightAInfoRequest < Questionnaire::MasterQuestionnaire
  def start_application(org, options = {})
    unless org.has_non_pending_8a_cert?
      raise "You must have a non-pending 8(a) certificate to make an information request"
    end

    SbaApplication::EightAInfoRequest.new(options.merge(organization: org, questionnaire: self, prerequisite_order: prerequisite_order, certificate: org.certificates.eight_a.first))
  end
end