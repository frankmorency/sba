# create me instead of a certificate for mpp_annual_renewal apps
# update original certificate's next_annual_report_date (migration for existing, and when an mpp cert becomes approved)

class AnnualReport < ActiveRecord::Base
  belongs_to  :certificate # the original cert that's getting a report
  belongs_to  :sba_application  # the annual report application itself
  belongs_to  :reviewer, class_name: 'User'

  STATUSES = %w(approved declined returned)
  APPROVED, DECLINED, RETURNED = STATUSES

  validates   :status, inclusion: STATUSES, allow_nil: true
  validates   :certificate, presence: true
  validates   :sba_application, presence: true

  def certificate_type
    certificate.try(:certificate_type)
  end

  def formatted_submission_date
    sba_application.created_at.strftime("%m/%d/%Y")
  end

  def status
    if read_attribute(:status) == "approved"
      "SBA_approved"
    elsif read_attribute(:status)
      read_attribute(:status).humanize
    end
  end

  def issue_date
    certificate.try(:issue_date)
  end

  def organization
    certificate.organization
  end

  def approve!(user)
    update_attributes(reviewer: user, status: APPROVED)
  end

  def decline!(user)
    update_attributes(reviewer: user, status: DECLINED)
  end

  def return_to_vendor!(user)
    transaction do
      update_attributes(reviewer: user, status: RETURNED, sba_application_id: sba_application.return_for_modification(true).id)
    end
  end

  def program
    certificate.program
  end

end
