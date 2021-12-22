class Organization < ActiveRecord::Base
  include CasesCSV
  if Feature.active?(:elasticsearch)
    update_index("cases_v2#organization") { self }
    update_index("agency_requirements") { agency_requirements }
  end

  PROGRAM_NAMES = ["mpp", "eight_a"]
  TRUNCATED_PROGRAM_NAMES = ["mpp", "eight_a"]

  BDMIS_HASH_SUFFIX = "SBAidealab01!!"

  acts_as_paranoid
  has_paper_trail

  has_many :personnels
  has_many :users, through: :personnels
  has_many :documents
  has_many :current_sba_applications, -> { where(is_current: true).order(created_at: :desc) }
  has_many :email_notification_histories
  has_many :sba_applications, -> { order(created_at: :desc) }
  # TODO: Do i need joins(:sba_application).where('sba_applications.is_current = ?', true)
  has_many :certificates, -> { where.not(workflow_state: "inactive").order(issue_date: :desc) }
  has_many :access_requests, { validate: false }
  has_many :agency_requirement_organizations
  has_many :agency_requirements, through: :agency_requirement_organizations
  has_many :adverse_action_reviews, class_name: "Review::AdverseAction", through: "certificates"
  has_many :intent_to_reviews, class_name: "Review::IntentTo", through: "certificates"

  has_one :voluntary_suspension

  delegate :dba_name, :duns, :mailing_address_line_1,
           :mailing_address_line_2, :mailing_address_city, :mailing_address_state_or_province,
           :mailing_address_zip_code_5, :mailing_address_zip_code_4, :govt_bus_poc_first_name,
           :govt_bus_poc_last_name, :govt_bus_poc_email, :govt_bus_poc_us_phone, :sam_address_1,
           :sam_address_2, :sam_city, :sam_province_or_state, :sam_zip_code_5, :sam_zip_code_4,
           :corporate_url, :dodaac, :sam_congressional_district, :tax_identifier_number, :duns_4,
           :primary_naics, :naics_code_string, :alt_govt_bus_poc_first_name, :alt_govt_bus_poc_last_name,
           :alt_govt_bus_poc_title, :alt_govt_bus_poc_email, :alt_govt_bus_poc_us_phone, :state_of_incorporation, :country_of_incorporation,
           :average_number_of_employees, :average_annual_revenue, :sam_extract_code,
           to: :sam_org, allow_nil: true

  validates :duns_number, uniqueness: true, on: :create
  validates :business_type, inclusion: { within: %w(llc corp s-corp partnership sole_prop Unknown) }

  before_create :compute_folder_name_value

  def self.with_certificates_updated_after(date)
    joins(:certificates).where("certificates.updated_at > ?", date)
  end

  def self.with_certificates_updated_before(date)
    joins(:certificates).where("certificates.updated_at < ?", date)
  end

  def test_bdmis_archive_and_migrate!
    SbaApplication::EightAMigrated.load!(self, {
      approval_date: "24-Sep-12",
      case_number: "302758",
      case_url: "https://sba8asdb.symplicity.com/manager/index.php?_mode=_form&id=0fef449536e29c766838ae7dc5dc6d17",
      certification: "8(a) Business Development (8(a) & SDB)",
      company_name: "Entity 79 Legal Business Name",
      decline_date: "null",
      ein: "743054820",
      next_review: "24-Sep-17",
      office: "942",
      page: "1",
      status: "8(a) Approved",
      submitted_on_date: "8/25/12 15:14",
      exit_date: "9/24/21",
      approved_date: "9/24/12",
      office_code: "912",
      office_name: "San Francisco",
      district_code: "942",
      district_name: "Fresno",
      duns: duns_number,
      hashed_duns: "",
    }, nil, nil)

    create_eight_a_annual_review!
  end

  def full_address
    return "#{mailing_address_line_1} #{city_state} #{mailing_address_zip_code}"
  end

  def has_terminal_8a_cert?
    eight_a_certificate.in_terminal_state?
  end

  def eight_a_certificate
    certificates.eight_a.first
  end

  def has_eight_a_certificate?
    eight_a_certificate
  end

  def last_eight_a_review_date
    if has_eight_a_certificate?
      eight_a_certificate.annual_review_applications.first.try(:review_for)
    end
  end

  def has_non_pending_8a_cert?
    Feature.active?(:request_for_info) && !(certificates.eight_a.empty? || certificates.eight_a.first.pending?)
  end

  def create_eight_a_annual_review!
    Questionnaire::EightAAnnualReview.create_application! self
  end

  def phone
    if sam_org
      sam_org.govt_bus_poc_us_phone
    else
      "INACTIVE IN SAM.GOV"
    end
  end

  def owner_name
    if sam_org
      "#{sam_org.govt_bus_poc_first_name} #{sam_org.govt_bus_poc_last_name}"
    else
      "INACTIVE IN SAM.GOV"
    end
  end

  def displayable_certificate_names(exclude_inactive = false)
    certs = certificates.select(:certificate_type_id, :workflow_state).distinct.reorder('')
    certs = certs.where.not(workflow_state: "inactive") if exclude_inactive
    certs
  end

  def displayable_certificates(exclude_inactive = false)
    certs = certificates.order(:issue_date)
    certs = certs.where.not(workflow_state: "inactive") if exclude_inactive
    certs
  end

  def certificates_by_program
    displayable_certificates.group_by(&:program)
  end

  def legal_business_name
    if sam_org.nil?
      "NOT FOUND IN SAM.GOV"
    else
      sam_org.legal_business_name
    end
  end

  def self.from_duns(duns_number)
    MvwSamOrganization.find_by(duns: duns_number).try(:to_org)
  end

  %w(business_start_date fiscal_year_end_close_date expiration_date).each do |field|
    define_method field do
      date_format field.to_sym
    end
  end

  def build_master_app(master_app_id, master_section_id)
    master_application = sba_applications.find(master_app_id)
    master_section = master_application.every_section.find_by(name: master_section_id)
    [master_application, master_section]
  end

  def entity_owned?
    false
  end

  def entity_owned
    false
  end

  def city_state
    if sam_org
      "#{mailing_address_city.humanize}, #{mailing_address_state_or_province}"
    else
      "INACTIVE IN SAM.GOV"
    end
  end

  def mailing_address_zip_code
    "#{mailing_address_zip_code_5}-#{mailing_address_zip_code_4}"
  end

  def sam_zip_code
    "#{sam_zip_code_5}-#{sam_zip_code_4}"
  end

  def has_sam_profile?
    sam_org.present?
  end

  def vendor_admin_user
    users.with_role(:vendor_admin).first
  end

  def default_user
    vendor_admin_user
  end

  def sam_org
    to_sam
  end

  def to_sam
    @sam_org ||= get_corresponding_sam_organization
  end

  def name
    get_corresponding_sam_organization.try(:legal_business_name)
  end

  def cage_code
    get_corresponding_sam_organization.try(:cage_codes)
  end

  def is_active?
    organization = MvwSamOrganization.get_extract_code_by_duns(self.duns_number)
    !organization.empty? && organization.first.sam_extract_code == "A"
  end

  def get_corresponding_sam_organization
    MvwSamOrganization.where("duns = :duns_number", duns_number: self.duns_number).first
  end

  def compute_folder_name_value
    self.folder_name = Digest::MD5.hexdigest("#{duns_number}#{tax_identifier}#{tax_identifier_type}")
  end

  def has_no_open_applications?(cert_type)
    !has_open_application?(cert_type)
  end

  def has_open_application?(cert_type)
    sba_applications.where(workflow_state: SbaApplication::OPEN_STATES).where("questionnaire_id in (?)", cert_type.current_questionnaires.collect(&:questionnaire_id)).count > 0
  end

  def has_any_draft_application?
    sba_applications.in_an_open_state.count > 0
  end

  def active_applications(cert_type)
    certificate_type = CertificateType.find_by(name: cert_type)
    sba_applications.where(workflow_state: SbaApplication::ACTIVE_STATES - ["complete"]).where(questionnaire: certificate_type.initial_questionnaires).size if certificate_type
  end

  def available_programs
    program_names = TRUNCATED_PROGRAM_NAMES
    program_names.reject! { |name| name == "asmpp" } unless Feature.active?(:asmpp)
    #program_names.reject! { |name| name == "edwosb" || "wosb" }

    # MIKE: This should use the initial application?  Or all questionnaires?
    Questionnaire.where(name: PROGRAM_NAMES).each do |questionnaire|
      program = questionnaire.name
      program_names.delete(program) if self.active_applications(program) >= questionnaire.maximum_allowed
    end

    program_names.map { |name| CertificateType.find_by_name(name).id }
  end

  def has_migrated_bdmis_application?
    sba_applications.where.not(bdmis_case_number: nil).count > 0
  end

  def business_type_display
    return BusinessType.get(business_type).display_name unless business_type == "Unknown"
    return "Unknown"
  end

  def next_action_due_date_oldest
    next_action_due_date(false)
  end

  def next_action_due_date_newest
    next_action_due_date(true)
  end

  def bdmis_migrated_data_s3_folder_name
    sha224 = OpenSSL::Digest::SHA224.new
    hashed_duns = sha224.hexdigest(duns + BDMIS_HASH_SUFFIX)
  end

  private

  def next_action_due_date(is_max)
    max = nil
    self.certificates.each do |cert|
      cert.reviews.each do |rvw|
        [:screening_due_date, :processing_due_date, :letter_due_date, :reconsideration_or_appeal_clock].each do |field|
          max = max_date(rvw, field, max, is_max)
        end
      end
    end
    max ? max.to_date : nil
  end

  def max_date(rec, field, max, is_max)
    val = rec.send(field)
    return max unless val
    val = val.to_date
    return val if max.nil?
    if is_max
      val < max ? max : val
    else # min
      val < max ? val : max
    end
  end

  def date_format(field)
    return nil if sam_org.nil? || sam_org.send(field).blank?
    begin
      sam_org.send(field) && I18n.l(Date.parse(sam_org.send(field)).to_date)
    rescue StandardError => e
      sam_org.send(field) && I18n.l(Date.strptime(sam_org.send(field), "%m/%d/%Y").to_date)
    end
  end
end
