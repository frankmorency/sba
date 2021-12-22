module SbaApplicationPresenter
  extend ActiveSupport::Concern

  def show_funbar?
    ! info_request?
  end

  def display_messages?
    true
  end

  def display_documents?
    true
  end

  def display_activity_log?
    true
  end

  def display_notes?(user)
    user.is_vendor_or_contributor? || info_request?
  end

  def formatted_submission_date
    application_submitted_at && application_submitted_at.strftime("%m/%d/%Y")
  end

  def display_status
    return 'Updates needed' if updates_needed?
    return 'Active' if current_review && current_review.workflow_state == 'retained'
    return 'Closed' if workflow_state == 'complete'
    return certificate.display_status if (current_review && current_review.workflow_state == 'appeal_intent')
    status
  end

  def display_kind
    kind.titleize
  end

  def to_s
    "#{certificate_type.try(:name)} for #{organization.try(:get_corresponding_sam_organization).try(:legal_business_name)}"
  end

  def masthead_subtitle
    if questionnaire.is_version_of? 'eight_a_annual_review'
      "For Program Year #{review_number}"
    end
  end

  def masthead_title
    if questionnaire.is_version_of? 'eight_a_migrated'
      'BDMIS Archive'
    elsif questionnaire.is_version_of? 'eight_a_annual_review'
      '8(a) Annual Review'
    elsif questionnaire.is_version_of? 'eight_a_info_request'
      '8(a) Information Request'
    elsif questionnaire.is_version_of? 'asmpp_initial'
      'ASMPP Application'
    else
      '8(a) Initial Application'
    end
  end
end
