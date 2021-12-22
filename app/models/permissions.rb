class Permissions
  include ActiveModel::Model

  STATUSES = %w(unassigned with_reviewer with_case_owner)
  UNASSIGNED, WITH_REVIEWER, WITH_CASE_OWNER = STATUSES

  attr_accessor :user, :review, :application

  validates   :user, presence: true

  def self.build(user, thing = nil)
    if thing.is_a?(SbaApplication)
      new(user: user, review: thing.current_review, application: thing)
    elsif thing&.is_really_a_review?
      new(user: user, review: thing, application: thing)
    elsif thing.is_a?(Review)
      new(user: user, review: thing, application: thing.sba_application)
    else
      new(user: user)
    end
  end

  def can_manage_agency_reqs?
    ! vendor_or_contributor?
  end

  def can_view_adhoc_footer?(contributor_section = nil)
    return true if is_boss?
    return true if is_case_owner?
    return true if is_reviewer?
    return true if user.is_vendor? && contributor_section.email.blank?  #TODO: TEST
    return true if user.is_contributor? && contributor_section.email.present?  #TODO: TEST

    false
  end

  def can_view_section_card_menu?
    if review_status
      case review_status
        when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
          return true if is_boss? || is_case_owner? || is_reviewer?
          return false
      end
    end

    return false if user.is_vendor?
    return false unless review && review.processing?
    return false unless is_case_owner?

    true
  end

  def can_request_section_revisions?
    return false unless review_status

    case review_status
      when Review::EightA::PROCESSING, Review::EightA::RETAINED
        return true if is_case_owner?
      when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_case_owner? || is_boss?
    end

    false
  end

  def can_add_note?
    ! vendor_or_contributor?
  end

  def can_send_message?
    if application&.info_request?
      return info_request_bos? && org_has_user_to_send_message?
    end

    return false unless review_status

    # Can't message if there are no users in the Org
    return false unless org_has_user_to_send_message?  #TODO: TEST

    case review_status
      when Review::EightA::SCREENING, Review::EightA::RETURNED_15_DAY, Review::EightA::RETURNED_DEFICIENCY
        is_case_owner? || user.is_vendor_or_contributor?
      when Review::EightA::PROCESSING, Review::EightA::RETAINED
        is_case_owner? || is_reviewer? || user.is_vendor_or_contributor?
      when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        is_case_owner? || is_reviewer? || user.is_vendor_or_contributor? || is_boss?
      else
        false
    end
  end

  def can_return_master_application?
    return false unless review_status

    case review_status
      when Review::EightA::SCREENING
        return true if is_case_owner?
      when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_case_owner? || is_boss?
    end

    false
  end

  def can_return_sub_application?
    return false unless review_status

    case review_status
      when Review::EightA::RETAINED
        return true if is_case_owner?
      when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_case_owner? || is_boss?
    end

    false
  end

  def can_upload_document?
    if application&.info_request?
      return info_request_bos?
    end

    # Allow Supervisors to Upload documents to a "returned" application. This was previous behavior which got broken in a prior refactor - APP-3917
    if application&.workflow_state == "returned"
      return true if is_boss? || is_analyst?
    end

    return false unless review_status

    case review_status
      when Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_boss? || is_case_owner? || is_reviewer?
        return false
    end

    ! vendor_or_contributor?
  end

  def can_return_to_owner?
    return false unless review_status
    return false unless is_referral?
    return true if is_case_owner? || is_reviewer?
    false
  end

  # USED FOR Adverse Actions right now
  def can_cancel?
    review_status != 'cancelled'
  end

  def can_refer_case?
    return false unless review_status

    case review_status
      when Review::EightA::RETURNED_DEFICIENCY
        return true if is_case_owner? || is_reviewer?
      when Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_boss? || is_case_owner? || is_reviewer?
    end

    false
  end

  def can_make_recommendation?
    return false unless review_status

    case review_status
      when Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_boss? || is_case_owner?
    end

    false
  end

  def can_make_determination?
    return false unless review_status

    case review_status
      when Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED
        return true if has_role?('sba_supervisor_8a_hq_aa')
      when Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if has_role?('sba_director_8a_district_office', 'sba_deputy_director_8a_district_office')
    end

    false
  end

  def can_retain_firm?
    return false unless review_status

    case review_status
      when Review::EightA::PROCESSING
        return true if is_case_owner?
    end

    false
  end

  def can_send_intent_to_terminate_letter?
    return false unless review_status

    case review_status
      when Review::EightA::SCREENING, Review::EightA::PROCESSING, Review::EightA::RETURNED_DEFICIENCY
        return true if is_case_owner? && application.is_annual?
    end

    false
  end

  def can_accept_for_processing?
    return false unless review_status

    case review_status
      when Review::EightA::SCREENING
        return true if is_case_owner? ||  has_role?('sba_supervisor_8a_hq_aa', 'sba_supervisor_8a_hq_program', 'sba_supervisor_8a_cods', 'sba_supervisor_8a_district_office', 'sba_director_8a_district_office', 'sba_deputy_director_8a_district_office')
    end

    false
  end

  def can_close_case?
    return false unless review_status

    case review_status
      when Review::EightA::SCREENING, Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::RETURNED_15_DAY, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_case_owner? || is_boss?
    end

    false
  end

  def can_reassign_case?
    return false unless review_status

    case review_status

      when Review::EightA::RECONSIDERATION, Review::EightA::SBA_DECLINED, Review::EightA::SBA_APPROVED, Review::EightA::RETURNED_15_DAY, Review::EightA::SCREENING, Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if has_role?('sba_supervisor_8a_hq_aa', 'sba_supervisor_8a_hq_program', 'sba_supervisor_8a_cods', 'sba_supervisor_8a_hq_ce', 'sba_supervisor_8a_district_office', 'sba_director_8a_district_office', 'sba_deputy_director_8a_district_office')
    end

    false
  end

  def can_reassign_annual_review_case?
    return false unless review_status

    case review_status
      when Review::EightAAnnualReview::SCREENING, Review::EightAAnnualReview::PROCESSING, Review::EightAAnnualReview::RETURNED_DEFICIENCY, Review::EightAAnnualReview::RETAINED, Review::EightAAnnualReview::EARLY_GRADUATION_RECOMMENDED, Review::EightAAnnualReview::TERMINATION_RECOMMENDED, Review::EightAAnnualReview::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if has_role?('sba_supervisor_8a_hq_aa', 'sba_supervisor_8a_hq_program', 'sba_supervisor_8a_cods', 'sba_supervisor_8a_hq_ce', 'sba_supervisor_8a_district_office', 'sba_director_8a_district_office', 'sba_deputy_director_8a_district_office')
    end

    false
  end

  def can_initiate_adverse_action?
    return false unless review_status

    case review_status
    when Review::EightA::SCREENING, Review::EightA::PROCESSING, Review::EightA::RETURNED_DEFICIENCY, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED, Review::EightAAnnualReview::SBA_APPROVED
        return true if is_case_owner? || is_boss?
    end

    false
  end

  def can_change_due_date?
    return false unless review_status

    case review_status
      when Review::EightA::SCREENING, Review::EightA::PROCESSING, Review::EightA::RETAINED, Review::EightA::EARLY_GRADUATION_RECOMMENDED, Review::EightA::TERMINATION_RECOMMENDED, Review::EightA::VOLUNTARY_WITHDRAWAL_RECOMMENDED
        return true if is_boss?
    end

    false
  end

  def can_indicate_reconsideration_or_appeal_received?
    return false unless review_status

    case review_status
      when Review::EightA::SBA_DECLINED, Review::EightA::PENDING_RECONSIDERATION_OR_APPEAL, Review::EightA::PENDING_RECONSIDERATION, Review::EightA::APPEAL_INTENT
        return true if is_case_owner? || has_role?('sba_supervisor_8a_cods', 'sba_supervisor_8a_hq_aa', 'sba_supervisor_8a_hq_program')
    end

    false
  end

  def is_reviewer?
    @reviewer ||= review && review.reviewer == user
  end

  def is_case_owner?
    @case_owner ||= review && review.case_owner == user
  end

  def is_referral?
    return false if review.reviewer.blank?
    return false if review.case_owner.blank?
    return false if review.reviewer == review.case_owner
    true
  end

  def org_has_user_to_send_message?
    application.organization.users.count >> 0
  end

  def is_boss?
    has_role?('sba_supervisor_8a_cods', 'sba_supervisor_8a_hq_program', 'sba_supervisor_8a_hq_aa', 'sba_supervisor_8a_district_office', 'sba_director_8a_district_office', 'sba_deputy_director_8a_district_office')
  end

  def is_analyst?
    has_role?('sba_analyst_8a_hq_program', 'sba_analyst_8a_cods', 'sba_supervisor_user', '  sba_analyst_8a_district_office')
  end

  def info_request_bos?
    user.is_servicing_bos?(application.organization)
  end

  def can_send_deficiency_letter_in_processsing?
    return false if review.nil?
    return false unless review.is_a? Review::EightAAnnualReview
    return false unless Review::EightA::PROCESSING == review_status
    return false unless is_application_with_SBA?
    return false unless is_case_owner?
    true
  end

  private

  def is_application_with_SBA?
    (application.returned_with_letter? || application.updates_needed? || application.awaiting_reconsideration_submission?) == false
  end

  def has_role?(*names)
    names.each do |name|
      return true if user.roles && user.roles.find {|role| role.name == name}
    end

    false
  end

  def review_status
    review.try(:workflow_state)
  end

  def vendor_or_contributor?
    ! user.roles.map(&:name).select {|name| name == 'vendor_admin' || name == 'contributor' }.empty?
  end
end
