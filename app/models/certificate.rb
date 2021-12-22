class Certificate < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index("cases_v2#organization") { organization }
    # Old index, remove when UI is retired
    # update_index('cases#certificate') { self }
  end

  include ActiveModel::Dirty
  include WorkflowWithHistory
  include CasesMashup
  include Searchable
  include CertificatePresenter
  FIELDS = {
    "DUNS" => "organizations.duns_number",
    "Program" => "certificate_types.name",
    "Status" => "workflow_state",
  }
  IGNORE = ["Review type", "Submitted", "Owner", "Current reviewer"]
  COUNTER = 25
  DEFAULT = "DUNS"

  searchable fields: FIELDS, default: DEFAULT, ignore: IGNORE, per_page: COUNTER

  ACTIVE_STATES = %w(pending active ineligible)

  HUMANIZE_NAME = {
    "MPP" => "MPP",
    "WOSB" => "WOSB",
    "EDWOSB" => "EDWOSB",
    "EIGHT_A" => "8(a)",
  }
  acts_as_paranoid
  # has_paper_trail

  scope :active, -> { where(workflow_state: "active") }

  has_many :reviews
  has_many :sba_applications
  has_many :annual_review_applications, -> { order(created_at: :desc) }, class_name: "SbaApplication::EightAAnnualReview"
  has_many :annual_reports
  has_many :adverse_action_reviews, class_name: "Review::AdverseAction"
  has_many :intent_to_reviews, class_name: "Review::IntentTo"

  belongs_to :organization
  belongs_to :certificate_type
  belongs_to :duty_station
  belongs_to :servicing_bos, class_name: User

  validates :organization, :certificate_type, presence: true

  before_validation :validate_certificate, on: :create

  def self.factory(attrs)
    type = "Certificate::#{attrs[:certificate_type].type.demodulize}"
    type.constantize.new(attrs)
  end

  def self.displayable
    where.not(workflow_state: "inactive")
  end

  def self.with_active_state
    where(workflow_state: ACTIVE_STATES)
  end

  def self.eight_a
    where(type: "Certificate::EightA").order(created_at: :desc)
  end

  def self.find_eight_a_by_organization_id(organization_id)
    where(
      "type = 'Certificate::EightA' AND organization_id = :organization_id",
      { organization_id: organization_id }
    )
    .first
  end

  def self.only_active
    where(workflow_state: "active")
  end

  def self.not_expired
    where("expiry_date >= ?", Date.today)
  end

  def label
    "#{self.type.split("::")[1]} (#{self.issue_date})"
  end

  def uses_master_apps?
    %w(Certificate::EightA).include? type
  end

  def doc_upload?
    app = initial_app || current_application
    return false unless app

    app.questionnaire.eight_a_master?
  end

  def clear_servicing_bos
    update(servicing_bos: nil)
  end

  def servicing_bos_name
    servicing_bos.blank? ? "None" : servicing_bos.name
  end

  def intend_to_appeal
    # Appeal is for 8(a) program only
    return false unless is_8a?
    current_application.current_review && current_application.current_review.appeal_intent?
  end

  def from_bdmis?
    !sba_applications.initial.first.bdmis_case_number.blank?
  end

  def application_in_draft?
    current_application.draft?
  end

  def application_in_reconsideration_process
    # Reconsideration  is for 8(a) program only
    return false unless is_8a?
    current_review && (current_review.pending_reconsideration_or_appeal? || current_review.pending_reconsideration? || current_review.reconsideration?)
  end

  def is_8a?
    certificate_type.name == "eight_a"
  end

  def initial_app
    current_application(SbaApplication::INITIAL)
  end

  def in_terminal_state?
    Certificate::EightA::TERMINAL_STATES.include? workflow_state.to_sym
  end

  def finalized?
    Certificate::EightA::FINALIZED_STATES.include? workflow_state.to_sym
  end

  def dashboard_display_app
    initial_app
  end

  def is_under_reconsideration?
    is_8a? && initial_app.is_eight_a_master_application? && initial_app.has_reconsideration_sections_and_ineligible_certificate?
  end

  def full_destroy
    transaction do
      sba_applications.destroy_all
      reviews.destroy_all
      destroy
    end
  end

  def returned_with_letter
    current_review.try(:returned_with_15_day_letter?) || current_review.try(:returned_with_deficiency_letter?)
  end

  def current_review(kind = nil)
    current_application(kind).reviews.order(created_at: "desc").first
  end

  def current_application(kind = nil)
    query = kind ? SbaApplication.where(kind: kind) : SbaApplication
    query.where(certificate_id: id).order(created_at: :desc).first
  end

  def other_certificates
    certificate_type.certificates.where(organization_id: organization_id)
  end

  def validate_certificate
    errors.add(:certificate, "already exists") unless valid_certificate?
  end

  def valid_certificate?
    return true unless Organization::PROGRAM_NAMES.include?(certificate_type.name)

    return true if current_application.try(:kind) == SbaApplication::ANNUAL_REVIEW

    num_active_certs = Certificate.where(certificate_type_id: certificate_type_id, organization_id: organization_id).where(workflow_state: ACTIVE_STATES).size

    num_active_certs <= current_application.questionnaire.maximum_allowed
  end

  def technically_expired?
    expiry_date && expiry_date <= Date.today
  end

  def decision
    review_decision || "Self Certified"
  end

  def start
    set_expiry_date
    set_issue_date
    update_annual_report_date if respond_to?(:update_annual_report_date)
  end

  def stop
    unset_expiry_date
    unset_issue_date
  end

  def on_active_entry(new_state, event, *args)
    start
  end

  def on_pending_entry(new_state, event, *args)
    # really?
    unset_expiry_date
  end

  def on_inactive_entry(new_state, event, *args)
    stop
  end

  def on_expire_entry(new_state, event, *args)
    most_recent_certificate.current_application.each do |app|
      app.expire!
    end
  end

  def needs_annual_report?(user)
    false
  end

  protected

  def unset_expiry_date
    update_attribute :expiry_date, nil
  end

  def unset_issue_date
    update_attribute :issue_date, nil
  end

  def set_issue_date
    unless issue_date
      update_attribute :issue_date, Time.now
    end
  end

  def set_expiry_date
    unless expiry_date || certificate_type.duration_in_days.nil?
      update_attribute :expiry_date, certificate_type.duration_in_days.days.from_now
    end
  end

  def review_decision
    review = Review.find_by(certificate_id: id, sba_application_id: current_application.id)

    return nil unless review

    if ["Complete", "Inactive"].include?(current_application.status) && review.determination
      review.determination.display_decision
    else
      nil
    end
  end

  def self.mark_certificates_as_expired
    # Expire all active certs that have a past expiry date to expired workflow_state
    # To do - Identify if there Should be any different behavior by Certificate type?
    Certificate.where(workflow_state: [:active]).where("expiry_date::date < ?", Date.today).each do |cert|
      cert.expire!
    end
  end

  def self.get_certificates_expiring_on(cert_types, expiry_date)
    # Active certs expirying on specifc date
    Certificate.where(workflow_state: ["active"])
      .where("expiry_date::date = ?", expiry_date)
      .joins(:certificate_type)
      .where(certificate_types: { name: cert_types })
  end

  def self.get_certificates_with_annual_review_due(cert_types, expiry_date)
    # Active certs expirying on specifc date
    Certificate::Mpp.where(workflow_state: ["active"])
      .where("next_annual_report_date::date = ?", expiry_date)
      .joins(:certificate_type)
      .where(certificate_types: { name: cert_types })
  end

  def self.process_email(certs, num_of_days, expiration_date)
    certs.each do |cert|
      # Check if there is a draft open for the same cert type and don't process email if one exists
      org = Organization.find(cert.organization_id)
      program = cert.certificate_type.super_short_name
      vendor_admin_email = org.vendor_admin_user.try(:email)

      if vendor_admin_email # If Business has no Vendor Admin currently
        # for edwosb & wosb
        # program is wosb / edwosb not mpp
        if program != "MPP" && org.sba_applications.where(workflow_state: "draft", questionnaire_id: cert.certificate_type.questionnaire("initial").id).count == 0
          business_name = org.name
          WosbExpiryReminderMailer.send_email(vendor_admin_email, num_of_days, expiration_date, business_name, program).deliver

          # for mpp ( we must have a questionnaire created for mpp_anual_review)
        elsif program == "MPP" && AnnualReport.where(certificate_id: cert.id).count == 0 && !cert.current_application.submitted?
          if num_of_days == 60
            #MppExpiryReminderMailer.send_60_day_reminder(cert, vendor_admin_email).deliver
          elsif num_of_days == 45
            #MppExpiryReminderMailer.send_45_day_reminder(cert, vendor_admin_email).deliver
          elsif num_of_days == 30
            #MppExpiryReminderMailer.send_30_day_reminder(cert, vendor_admin_email).deliver
          elsif num_of_days == -1
            #MppExpiryReminderMailer.send_past_1_day_reminder(cert, vendor_admin_email).deliver
          end
        end
      end

      EmailNotificationHistory.create(organization_id: org.id, program: program, days: num_of_days, email: vendor_admin_email)
    end
  end
end
