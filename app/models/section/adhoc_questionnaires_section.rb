require_relative '../section/sub_application'

class Section::AdhocQuestionnairesSection < Section::SubApplication
  include NotificationsHelper

  def status
    "ITS_COMPLICATED" # defer to other sections my children are associated with
  end

  def create_adhoc_app(adhoc_request)    
    transaction do
      q = Questionnaire.find_by(name: adhoc_request.questionnaire_type)

      related_section = sba_application.master_application_section.descendants.where(type: 'Section::SubApplication').find_by(name: adhoc_request.sub_section_name)

      creator = related_section.email.blank? ? sba_application.creator : User.find_by(email: related_section.email)

      unless creator
        raise "email=#{related_section.email} app=#{sba_application.inspect} user=#{User.find_by(email: related_section.email).inspect}"
      end

      app = SbaApplication::SubApplication.create!(
          organization: sba_application.organization,
          questionnaire: q,
          master_application: sba_application,
          master_section: sba_application.master_application_section,
          kind: SbaApplication::ADHOC,
          adhoc_question_title: adhoc_request.topic,
          adhoc_question_details: adhoc_request.message_to_firm_owner,
          creator: creator
      )

      s = Section::SubApplication.create! name: adhoc_request.unique_name,
                                          title: q.title,
                                          position: 7,
                                          submit_text: 'Save and continue',
                                          parent: self,
                                          questionnaire: q,
                                          related_to_section: related_section,
                                          sba_application: sba_application,
                                          status: Section::NOT_STARTED,
                                          sub_application: app,
                                          sub_questionnaire: q

      if (Feature.active? :notifications) && creator
        send_application_adhoc_questionnaire_requested("8(a)", master_application_type(sba_application), app.creator_id, sba_application.id, app.creator.email)
      end
    end
  end
end