class Review::ASMPP < Review::Master
  include NotificationsHelper

  STATUSES = %w(screening processing sba_declined sba_approved closed)
  SCREENING, PROCESSING, SBA_DECLINED, SBA_APPROVED, CLOSED = STATUSES

  STATE_LABELS = {
      SCREENING => 'Screening in Progress',
      PROCESSING => 'Processing',
      SBA_DECLINED => 'Declined',
      SBA_APPROVED => 'Approved',
      CLOSED => 'Closed'
  }

  def self.create_and_assign_review(user, application)
    # return nil unless user.can_any_role?(:sba_analyst_8a_cods, :sba_supervisor_8a_cods, :sba_supervisor_8a_hq_aa, :sba_supervisor_8a_district_office, :sba_analyst_8a_district_office, :sba_supervisor_8a_hq_program)

    create_and_assign_review(user, application, ASMPPAssignment, Review::ASMPP::SBA_APPROVED)
  end

  def determination_made_sba_approved
    certificate.determination_made_sba_approved!
    send_determination_notification("approved")
  end

  def determination_made_decline_ineligible
    certificate.determination_made_decline_ineligible!
    send_determination_notification("declined")
  end

  def process
    update_attribute :processing_due_date, 90.days.from_now.to_date
    user = sba_application.users.select{|u| u.has_role?(:vendor_admin)}.first
    send_application_accepted_notification("asmpp", master_application_type(sba_application), user.id, sba_application.id, user.email)
  end

  private

  def send_determination_notification(subtype)
    vendor_admin = sba_application.organization.vendor_admin_user
    [vendor_admin].each do |user|
      send_notification_determination_made("asmpp", master_application_type(sba_application), subtype, user.id, sba_application.id, user.email)
    end
  end
end
