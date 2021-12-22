class Review::EightA < Review::Master
  include NotificationsHelper

  STATUSES = %w(screening processing retained early_graduation_recommended termination_recommended voluntary_withdrawal_recommended returned_with_15_day_letter returned_with_deficiency_letter determination_made sba_declined sba_approved pending_reconsideration_or_appeal pending_reconsideration appeal_intent appeal reconsideration)
  SCREENING, PROCESSING, RETAINED, EARLY_GRADUATION_RECOMMENDED, TERMINATION_RECOMMENDED, VOLUNTARY_WITHDRAWAL_RECOMMENDED, RETURNED_15_DAY, RETURNED_DEFICIENCY, DETERMINATION_MADE, SBA_DECLINED, SBA_APPROVED, PENDING_RECONSIDERATION_OR_APPEAL, PENDING_RECONSIDERATION, APPEAL_INTENT, APPEAL, RECONSIDERATION = STATUSES

  STATE_LABELS = {
    SCREENING => "Screening in Progress",
    PROCESSING => "Processing",
    RETAINED => "Retained",
    EARLY_GRADUATION_RECOMMENDED => "Early Graduation (recommended)",
    TERMINATION_RECOMMENDED => "Termination (recommended)",
    VOLUNTARY_WITHDRAWAL_RECOMMENDED => "Voluntary Withdrawal (recommended)",
  }

  DENIED_STATUSES = %w(pending_reconsideration_or_appeal pending_reconsideration appeal_intent)

  def self.create_and_assign_review(user, application)
    return nil unless user.can_any_role?(:sba_analyst_8a_cods, :sba_supervisor_8a_cods, :sba_supervisor_8a_hq_aa, :sba_supervisor_8a_district_office, :sba_analyst_8a_district_office, :sba_supervisor_8a_hq_program, :sba_director_8a_district_office, :sba_deputy_director_8a_district_office)

    create_and_assign_review(user, application, EightAAssignment, Review::EightA::SBA_APPROVED)
  end

  def self.clear_denied_statuses!
    Review::EightAInitial.where(workflow_state: DENIED_STATUSES).where("reconsideration_or_appeal_clock <= ?", 90.days.ago).map(&:close!)

    # remove declined applications a year after review.pending_reconsideration_or_appeal_clock for the oldest application

    # select org IDs that have the right reviews.reconsideration_or_appeal_clock values
    org_rs = Organization
               .joins("INNER JOIN sba_applications on sba_applications.organization_id = organizations.id")
               .joins("INNER JOIN reviews on sba_applications.id = reviews.sba_application_id")
               .where("sba_applications.type like '%EightAMaster'")
               .where("reviews.reconsideration_or_appeal_clock is not null and reviews.reconsideration_or_appeal_clock <= (current_timestamp - interval '1' year)")
    org_ids = org_rs.map(&:id).uniq

    org_ids.each do |org_id|

      # retrieve from SbaApplication query batch by orgs and save IDs
      # sort by created_at timestamp desc (latest record 1st in recordset)
      sba_applications = SbaApplication
                           .joins("INNER JOIN organizations on sba_applications.organization_id = organizations.id")
                           .joins("INNER JOIN reviews on sba_applications.id = reviews.sba_application_id")
                           .where("organizations.id = ?", org_id)
                           .where("sba_applications.type like '%EightAMaster'")
                           .where("reviews.reconsideration_or_appeal_clock is not null and reviews.reconsideration_or_appeal_clock <= (current_timestamp - interval '1' year)")
                           .order("reviews.reconsideration_or_appeal_clock")

      num_of_applications = sba_applications.all.length

      if (num_of_applications >= 3 && sba_applications.last.reviews.first.reconsideration_or_appeal_clock <= 1.year.ago)
        sba_applications_ids = sba_applications.map(&:id)

        # Soft delete contributors
        Contributor
          .where(sba_application_id: sba_applications_ids)
          .update_all(deleted_at: DateTime.now())

        # Soft delete sub-applications
        SbaApplication
          .where(master_application_id: sba_applications_ids, type: 'SbaApplication::SubApplication')
          .update_all(deleted_at: DateTime.now())

        # Soft delete certificates
        certs_ids = sba_applications.map(&:certificate_id)
        Certificate.where(id: certs_ids).update_all(deleted_at: DateTime.now())

        # Soft delete applications
        sba_applications.update_all(deleted_at: DateTime.now())
      end
    end
  end

  def start_pending_reconsideration_or_appeal_clock
    update_attributes!({ reconsideration_or_appeal_clock: Time.now })
  end

  def user_submit_appeal
  end

  def user_submit_appeal_intent
  end

  def user_submit_reconsideration
  end

  def send_15_day_letter
    sba_application.update_attributes(returned_reviewer: sba_application.current_review.current_assignment.reviewer)
  end

  def determination_made_sba_approved
    certificate.determination_made_sba_approved!
    send_determination_notification("approved")
  end

  def determination_made_decline_ineligible
    certificate.determination_made_decline_ineligible!
    send_determination_notification("declined")
  end

  def due_date_days
    return nil unless due_date

    return (processing_due_date - processing_pause_date).to_i if processing_paused?

    super
  end

  def due_date
    return letter_due_date if returned_with_15_day_letter? || returned_with_deficiency_letter?

    super
  end

  def process
    update_attribute :processing_due_date, 90.days.from_now.to_date
    user = sba_application.users.select { |u| u.has_role?(:vendor_admin) }.first
    send_application_accepted_notification("8(a)", master_application_type(self.sba_application), user.id, self.sba_application.id, user.email)
  end

  def process_for_reconsideration
    update_attribute :processing_due_date, 45.days.from_now.to_date

    # notifications
    # user = sba_application.users.select{|u| u.has_role?(:vendor_admin)}.first
    # send_application_accepted_notification("8(a)", eight_a_application_type(self.sba_application), user.id, self.sba_application.id, user.email)
  end

  def returned_with_deficiency_letter_while_in_processing?
    workflow_states = self.workflow_changes.order("created_at DESC").map(&:workflow_state)
    index = workflow_states.index("returned_with_deficiency_letter")
    index && (workflow_states[index + 1] == "processing") # Check if it was a case of a returned_with_deficiency_letter from processing state.
  end

  private

  def pause_business_units
    ops_id = BusinessUnit.find_by_name("OPS").id
    size_id = BusinessUnit.find_by_name("SIZE").id
    [ops_id, size_id]
  end

  def pause_conditions(selected_business_unit)
    return false if selected_business_unit.nil?
    self.processing? && pause_business_units.include?(selected_business_unit.id)
  end

  def pause_processing
    self.processing_pause_date = Date.today
    self.processing_paused = true
    save!
  end

  def resume_conditions(selected_business_unit)
    return false if selected_business_unit.nil?
    self.processing_paused && !pause_business_units.include?(selected_business_unit.id)
  end

  def resume_processing
    self.processing_paused = false
    self.processing_due_date = calculate_new_processing_due_date
    self.processing_pause_date = nil
    save!
  end

  def calculate_new_processing_due_date
    # Check if it was a case of a review in processing returned with deficiency letter.
    if returned_with_deficiency_letter_while_in_processing?
      return self.processing_due_date
    end
    if self.processing_due_date == nil
      return nil
    end
    return self.processing_due_date if self.processing_pause_date == nil && self.processing_due_date != nil
    self.processing_due_date + (Date.today - self.processing_pause_date)
  end

  def send_determination_notification(subtype)
    vendor_admin = sba_application.organization.vendor_admin_user
    [vendor_admin].each do |user|
      send_notification_determination_made("8(a)", master_application_type(sba_application), subtype, user.id, sba_application.id, user.email)
    end
  end
end
