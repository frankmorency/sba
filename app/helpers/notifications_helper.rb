# FEARLESS NOTIFICATIONS TYPES: https://sbaone.atlassian.net/wiki/spaces/FEAR/pages/83565825/Notification+Types

# Created by Rails
module NotificationsHelper

  def send_official_message(message_obj, sender, recipient, app)
    my_params = {
      subject: message_obj.subject,
      "body" => message_obj.message,  # This must use this syntax or API will crash.
      user_1: sender.id,
      user_2: recipient.id,
      recipient_id: recipient.id,
      sender_id: sender.id,
      application_id: app.id,
      conversation_type: "official"
    }

    CertifyMessages::Conversation.create_with_message(MessagesHelper::sanitize_message(my_params))
  end

  def send_notification_and_email_of_returned_application(app, the_return, current_user, official)
    app.organization.users.each do |u|
      send_application_returned_notification("8(a)", master_application_type(app), u.id, app.id, u.email)
    end

    user = app.users.select {|u| u.has_role?(:vendor_admin) }.first

    my_params = {
        subject: the_return.subject,
        "body" => the_return.message,  # This must use this syntax or API will crash.
        user_1: current_user.id,
        user_2: user.id,
        recipient_id: user.id,
        sender_id: current_user.id,
        application_id: app.id
    }

    if official
      my_params["conversation_type"] = "official"
    end

    CertifyMessages::Conversation.create_with_message(MessagesHelper::sanitize_message(my_params))
  end

	def send_message_notification(program, application_type, sender_name, recipient_id, application_id, email)
    obj = {
      "recipient_id" => recipient_id,
      "application_id" => application_id,
      "email" => email,
      "event_type" => 'message',
      "subtype" => 'message_sent',
      "certify_link" => "/sba_applications/#{application_id}/conversations",
      "priority" => true,
      "options" => { sender_name: sender_name , program_name: program, application_type: application_type }
    }

    run_notification(obj)
  end

  def send_application_submited_notification(application)
    users = Role.find_by_name("sba_supervisor_8a_cods").users
    users.each do |user|
      obj = {
        strict: false,
        event_type: 'application_status_change',
        subtype: 'submitted',
        recipient_id: user.id,
        application_id: application.id,
        priority: false,
        email: user.email,
        certify_link: '/eight_a_initial_sba_supervisor/dashboard',
        options:{ business_name: application.organization.name, program_name: '8(a)', application_type: master_application_type(application) }
      }
      run_notification(obj)
    end
  end


  def send_application_resubmitted_notification(application)
    if application.returned_reviewer
      obj = {
        strict: false,
        event_type: 'application_status_change',
        subtype: 'resubmitted',
        recipient_id: application.returned_reviewer_id,
        application_id: application.id,
        email: application.returned_reviewer.email,
        certify_link: '/eight_a_initial_sba_analyst/dashboard',
        options:{ business_name: application.organization.name, program_name: '8(a)', application_type_or_section: master_application_type(application) }
      }
      run_notification(obj)
    end
  end

  def send_application_accepted_notification(program, application_type, recipient_id, application_id, email)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: 'accepted',
      application_id: application_id,
      recipient_id: recipient_id,
      email: email,
      certify_link: "/sba_application/#{self.sba_application.id}/application_dashboard/overview",
      options:{ program_name: program, application_type: application_type }
    }
    run_notification(obj)
  end


  def send_application_returned_notification(program, application_type_or_section, recipient_id, application_id, email)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: "returned",
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_applications/#{application_id}/conversations",
      options:{ program_name: program, application_type_or_section: application_type_or_section }
    }
    run_notification(obj)
  end

  def send_application_adhoc_questionnaire_requested(program, application_type_or_section, recipient_id, application_id, email)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: "adhoc_requested",
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_application/#{application_id}/application_dashboard/overview",
      options:{ program_name: program, application_type_or_section: application_type_or_section }
    }
    run_notification(obj)
  end

  def send_application_adhoc_questionnaire_responded(program, application_type_or_section, recipient_id, application_id, email, biz_name)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: "adhoc_submitted",
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_application/#{application_id}/application_dashboard/overview",
      options:{ program_name: program, application_type_or_section: application_type_or_section, business_name: biz_name }
    }
    run_notification(obj)
  end

  def send_application_info_requested(program, application_type_or_section, recipient_id, application_id, email)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: "adhoc_requested",
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_application/#{application_id}/application_dashboard/overview",
      options:{ program_name: program, application_type_or_section: application_type_or_section }
    }
    run_notification(obj)
  end

  def send_application_info_responded(program, application_type_or_section, recipient_id, application_id, email, biz_name)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: "adhoc_submitted",
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_application/#{application_id}/application_dashboard/overview",
      options:{ program_name: program, application_type_or_section: application_type_or_section, business_name: biz_name }
    }
    run_notification(obj)
  end

  def send_application_reconsideration_responded(program, application_type_or_section, recipient_id, application_id, email, biz_name)
    obj = {
        strict: false,
        event_type: 'application_status_change',
        subtype: "reconsideration_submitted",
        recipient_id: recipient_id,
        application_id: application_id,
        email: email,
        certify_link: "/sba_application/#{application_id}/application_dashboard/overview",
        options:{ program_name: program, application_type: application_type_or_section, business_name: biz_name }
    }
    run_notification(obj)
  end

  def send_notification_determination_made(program, application_type, subtype, recipient_id, application_id, email)
    obj = {
      strict: false,
      event_type: 'application_status_change',
      subtype: subtype,
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: "/sba_applications/#{application_id}/conversations",
      options:{ program_name: program, application_type: application_type }
    }
    run_notification(obj)
  end

  def send_notification_to_refered(program, application_type, subtype, recipient_id, application_id, email, business_name=nil, case_number=nil)

    if case_number
      organization = Review::OutOfCycle.get(case_number).organization
      certify_link = "/organizations/#{organization.id}/adverse_action_reviews/#{case_number}"
    else
      certify_link = "/sba_application/#{application_id}/application_dashboard/overview"
    end

    obj = {
      strict: false,
      event_type: 'application_assignment',
      subtype: subtype,
      recipient_id: recipient_id,
      application_id: application_id,
      email: email,
      certify_link: certify_link,
      options: options = { program_name: program, application_type: application_type, business_name: business_name}
    }
    run_notification(obj)
  end

  def send_application_closed_notification(program, application_type, recipient_id, application_id, email)
    obj = {
        strict: false,
        event_type: 'application_status_change',
        subtype: 'closed',
        application_id: application_id,
        recipient_id: recipient_id,
        email: email,
        certify_link: "/sba_applications/#{application_id}/conversations",
        options:{ program_name: program, application_type: application_type }
    }
    run_notification(obj)
  end

  private

  def master_application_type(application)
    # set application type based on application kind
    case application.kind
    when 'annual_review'
      'Annual Review'
    when 'initial'
      'Initial'
    when 'info_request' # fix later
      'Initial'
    when 'adverse_action'
      'Adverse Action'
    else
      raise "The application kind #{application.kind} is not defined in the notification-api"
    end
  end

  def run_notification(obj)
    CertifyNotifications::Notification.create(obj) if Feature.active?(:notifications)
  end
end
