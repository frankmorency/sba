class Certificate::Mpp < Certificate
  include CertificateWorkflow
  include CasesMashup

  has_many   :annual_reports, foreign_key: 'certificate_id'
  belongs_to :original_certificate, class_name: 'Certificate::Mpp'

  before_create   :update_annual_report_date

  def decision
    review_decision || ''
  end

  def needs_annual_report?(user)
    return false unless user.can?(:ensure_vendor, user)
    return false unless active? || expired?
    # this will fail next year
    return false unless annual_reports.count == 0
    # need a place to store these notification periods for annual reports
    return false unless next_annual_report_date && next_annual_report_date <= (Date.today + 60)
    return false unless SbaApplication.where(original_certificate_id: id).count == 0

    true
  end

  def renewable?(user)
    return false unless user.can?(:ensure_vendor, user)

    return false unless  active? || expired?

    # make sure there's not already an existing one for this cert
    if Certificate.where(original_certificate_id: id).count > 0 || SbaApplication.where(original_certificate_id: id).count > 0
      return false
    end

    if expired?
      return false if most_recent_certificate.active? || most_recent_certificate != self
    end

    expiry_date && Date.today >= expiry_date.to_date - certificate_type.renewal_notification_period_in_days
  end

  def update_annual_report_date
    if CertificateType::Mpp.first.annual_report_period_in_days && issue_date
      self.next_annual_report_date = issue_date.to_date + CertificateType::Mpp.first.annual_report_period_in_days
    end
  end

  def self.declined
    # determination_id 2 is declined
    initial_mpp_certs = Review.where(workflow_state: 'determination_made').joins(:determination).where(determinations: {decision: "decline_ineligible"}).select{|ar| ar.certificate != nil }.map{|ar| ar.certificate}
    annual_mpp_certs = AnnualReport.where(status: 'declined').joins(:certificate).map{|ar| ar.certificate}
    certs = annual_mpp_certs + initial_mpp_certs
    certs.select{ |c| c.type == "Certificate::Mpp" }
  end

  def self.returned_to_vendor
    # I think i need to make sure that there is no new application unsubmited.
    initial_mpp_certs = Certificate.where(workflow_state: 'inactive' ).select{ |cert| cert.certificate_type_id == 3 }.map{ |cert| cert.current_application }.select{ |cert| cert.workflow_state == "draft"}.map{ |app| app.certificate }
    annual_mpp_certs = AnnualReport.where(status: 'returned').joins(:certificate).map{|ar| ar.certificate}
    certs = annual_mpp_certs + initial_mpp_certs
    certs.select{ |c| c.type == "Certificate::Mpp" }
  end
end
