require 'timeout'

# Created by Rails
module ActivityLogHelper

  def log_activity_application_state_change(new_state, application_id, user_id, sub_app_id=nil)
    return unless is_eight_a_program(application_id) # log activity for 8a initial and annual review only
    raise "The application state #{new_state} is not defined in the activity-api" if valid_application_state_change_events.exclude?(new_state)

    activity_params = {
      activity_type: 'application',
      event_type: 'application_state_change', # application, application_state_change
      subtype: new_state,
      recipient_id: user_id,
      application_id: application_id
    }

    # set the required parameters based on the event_type
    case new_state
      when 'submitted_section', 'resubmitted_section', 'returned_section'
        activity_params["options"] = { application_id: application_id, application_section_title: get_app_section_title(sub_app_id), user_id: user_id, user_name: get_user_full_name(user_id) }
      else
        activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id) }
    end

    # call activity log service
    create_activity_log(activity_params)
  end

  def log_activity_application_event(event, application_id, user_id = nil, event_subject_id = nil)
    return unless is_eight_a_program(application_id) # log activity for 8a initial and annual review only

    # event_subject_id will be new_user_id, note_id, contributor_id depending on the event
    activity_params = {
      activity_type: 'application',
      event_type: 'application', # application, application_state_change
      subtype: event,
      recipient_id: user_id,
      application_id: application_id
    }

    # set the required parameters based on the event_type
    case event
    when 'created'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id) }
    when 'created_system'
      activity_params["options"] = { application_id: application_id }
    when 'owner_changed'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id), new_user_id: event_subject_id, new_user_name: get_user_full_name(event_subject_id) }
    when 'reviewer_changed'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id), new_user_id: event_subject_id, new_user_name: get_user_full_name(event_subject_id) }
    when 'note_created'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id), note_id: event_subject_id, note_title: get_note_title(event_subject_id) }
    when 'contributor_added'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id), contributor_id: event_subject_id, contributor_name: get_contributor_name(event_subject_id) }
    when 'contributor_removed'
      activity_params["options"] = { application_id: application_id, user_id: user_id, user_name: get_user_full_name(user_id), contributor_id: event_subject_id, contributor_name: get_contributor_name(event_subject_id) }
    else
      raise "The application event #{event} is not defined in the activity-api"
    end

    # call activity log service
    create_activity_log(activity_params)
  end

  def log_activity_application_certificate_event(event, application_id, user_id, attribute_name , old_value, new_value, reason = "")
    activity_params = {
      activity_type: 'application',
      event_type: 'application',
      subtype: event,
      application_id: application_id,
      user_id: user_id
    }

    activity_params["options"] = { 
      application_id: application_id,
      user_id: user_id,
      user_name: get_user_full_name(user_id),
      attribute_name: attribute_name,
      old_value: old_value,
      new_value: new_value,
      reason: reason
    }

    # call activity log service
    create_activity_log(activity_params)
  end

  private

  def create_activity_log(activity_params)
    return unless Feature.active?(:activity_log) # Skip api call
    # If the activity log service is down, Certify will log these errors and allow the original transaction to be successful
    begin
      CertifyActivityLog::Activity.create(MessagesHelper::sanitize_message(activity_params))
    rescue => e
      Rails.logger.error "Activity log service is down: #{e.message} #{activity_params}"
    end
  end

  def is_eight_a_program(application_id)
    sba_application = SbaApplication.find_by_id(application_id)
    return false if sba_application&.program.blank?
    sba_application.program.name == 'eight_a'
  end

  def valid_application_state_change_events
    %w(submitted
    resubmitted
    returned
    screening
    accepted_processing
    submitted_section
    resubmitted_section
    returned_section
    closed_unresponsive
    recommended_eligible
    recommended_ineligible
    recommended_early_graduation
    recommended_termination
    recommended_withdrawal
    withdrawal_requested
    withdrawal_accepted
    determined_eligible
    determined_ineligible
    reconsideration_submitted_by_mail
    appeal_submitted_by_mail
    adhoc_requested
    adhoc_submitted)
  end

  def get_app_section_title(application_id)
    return "" if application_id.nil?
    app = SbaApplication.find_by_id(application_id)
    app&.section&.title
  end

  def get_user_full_name(user_id)
    user = User.find_by_id(user_id)
    user.first_name + ' ' + user.last_name
  end

  def get_contributor_name(contributor_id)
    Contributor.unscoped.find_by_id(contributor_id).full_name
  end

  def get_note_title(note_id)
    Note.find_by_id(note_id).title
  end
end