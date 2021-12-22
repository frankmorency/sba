require_relative '../section/sub_application'

class Section::ReconsiderationSection < Section::SubApplication
  include NotificationsHelper

  def is_last?
    last_section = self.sba_application.last_reconsideration_section
    return nil if last_section.nil?
    position == last_section.position
  end

  def create_reconsideration_app(reconsideration_request, reconsideration_questionnaire)
    transaction do
      app = SbaApplication::SubApplication.create!(
          organization: sba_application.organization,
          questionnaire: reconsideration_questionnaire,
          master_application: sba_application,
          master_section: sba_application.master_application_section,
          kind: Questionnaire::RECONSIDERATION,
          adhoc_question_title: reconsideration_request.topic,
          adhoc_question_details: reconsideration_request.message_to_firm_owner,
          creator: sba_application.creator
      )

      self.update_attributes!({sub_application: app})
    end
  end
end