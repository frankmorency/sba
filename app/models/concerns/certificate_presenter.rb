module CertificatePresenter
  extend ActiveSupport::Concern

  def title
    case dashboard_display_app.try(:questionnaire).try(:name)
      when 'eight_a_migrated'
        'BDMIS Archive'
      when 'eight_a_initial'
        '8(a) Initial Application'
      when 'eight_a_annual_review'
        '8(a) Annual Review'
      else
        certificate_type.initial_questionnaire.link_label
    end
  end

  def display_kind
    'Certificate'
  end

  def formatted_expiry_date
    return nil unless expiry_date && !ineligible?
    expiry_date.strftime("%m/%d/%Y")
  end

  def formatted_submission_date
    if uses_master_apps?
      sba_applications.where(type: "SbaApplication::EightAMaster").first&.formatted_submission_date
    else
      current_application&.formatted_submission_date
    end
  end

  def display_decision
    return nil unless decision
    decision
  end

  def display_status
    return status if finalized?
    return "Updates needed" if current_application(SbaApplication::INITIAL)&.updates_needed?
    return 'BDMIS Rejected' if current_application.certificate.workflow_state == 'bdmis_rejected'
    return 'Closed' if current_application.workflow_state == 'complete' && current_application.certificate.workflow_state != 'active'
    status
  end
end
