class InformationRequest
  include ActiveModel::Model
  include NotificationsHelper

  attr_accessor :topic, :message_to_firm_owner, :text, :attachment, :organization_id, :assigned_to, :deliver_to

  def organization_header
    "#{organization.name.upcase} (#{organization.duns})"
  end

  def creator
    organization.users.find(deliver_to)
  end

  def organization
    @organization ||= Organization.find(organization_id)
  end

  def vendor_admin
    organization.vendor_admin_user
  end

  def sub_section_name
    topic
  end

  def create_application!
    Questionnaire.transaction do
      original_cert = organization.certificates.eight_a.first

      app = Questionnaire::EightAInfoRequest.first.start_application(organization)
      app.creator = creator
      app.info_request_assigned_to = assigned_to
      app.duty_stations << original_cert.duty_station if original_cert&.duty_station
      app.save!

      q = Questionnaire.find_by(name: questionnaire_type)

      sub_app = SbaApplication::SubApplication.create!(
          organization: organization,
          questionnaire: q,
          master_application: app,
          master_section: app.master_application_section,
          kind: SbaApplication::INFO_REQUEST, # don't treat this like an adhoc on initial which can have it's own separate review process
          adhoc_question_title: topic,
          adhoc_question_details: message_to_firm_owner,
          creator: vendor_admin
      )

      Section::SubApplication.create! name: unique_name,
                                      title: q.title,
                                      position: 7,
                                      submit_text: 'Save and continue',
                                      parent: app.master_application_section,
                                      questionnaire: q,
                                      sba_application: app,
                                      status: Section::NOT_STARTED,
                                      sub_application: sub_app,
                                      sub_questionnaire: q

      ApplicationController.helpers.log_activity_application_state_change('adhoc_requested', app.id, assigned_to.id)
      if (Feature.active? :notifications) && vendor_admin
        send_application_adhoc_questionnaire_requested("8(a)", "participation", sub_app.creator_id, app.id, sub_app.creator.email)
      end
    end
  end

  def text
    @text == "1"
  end

  def attachment
    @attachment == "1"
  end

  def unique_name
    "#{topic.split(/\W+/).map(&:downcase).join("_")}_#{Time.now.to_i}"
  end

  def questionnaire_type
    if text && attachment
      Questionnaire::ADDHOC_TEXT_AND_ATTACHMENT
    elsif text
      Questionnaire::ADHOC_TEXT
    elsif attachment
      Questionnaire::ADHOC_ATTACHMENT
    else
      raise "You must select text or attachment"
    end
  end
end