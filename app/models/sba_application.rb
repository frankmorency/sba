#require 'exception_notification'
require "new_relic/agent/method_tracer"

class SbaApplication < ActiveRecord::Base
  include Sectionable
  include ActiveModel::Dirty
  include WorkflowWithHistory
  include SbaApplicationMaster
  include SbaApplicationVersioning
  include SbaApplicationPresenter

  if Feature.active?(:elasticsearch)
    update_index("cases_v2#organization") { organization }
    update_index("agency_requirements") { organization }
    # Old index, remove when UI is retired
    #update_index('cases#certificate') do
    #  certificate unless self.type == "SbaApplication::SubApplication"
    #end
  end

  OPEN_STATES = %w(draft returned) unless defined?(OPEN_STATES)
  ACTIVE_STATES = %w(draft submitted under_review complete returned) unless defined?(ACTIVE_STATES)

  DISTRICT_NON_ACTIVE_STATES = %w(cancelled closed early_graduated terminated voluntary_withdrawn)
  CODS_NON_ACTIVE_STATES = %w(cancelled closed early_graduated terminated voluntary_withdrawn pending_reconsideration)

  KINDS = %w(initial annual_review adhoc reconsideration info_request entity_owned_initial) unless defined?(KINDS)
  INITIAL, ANNUAL_REVIEW, ADHOC, RECONSIDERATION, INFO_REQUEST, ENTITY_OWNED_INITIAL = KINDS unless defined?(INITIAL)

  acts_as_paranoid
  has_paper_trail

  belongs_to :questionnaire
  belongs_to :organization
  belongs_to :certificate
  belongs_to :current_section, class_name: "Section"
  belongs_to :original_certificate, class_name: "Certificate::Mpp"
  belongs_to :returned_reviewer, class_name: "User"
  belongs_to :info_request_assigned_to, class_name: "User"
  belongs_to :creator, class_name: "User"

  # SECTION ASSOCIATIONS
  has_many :every_section, class_name: "Section", dependent: :destroy
  has_many :dynamic_sections, -> { (where(dynamic: true)) }, class_name: "Section"
  has_many :section_spawners, class_name: "Section::Spawner"
  has_many :sections, -> { where("displayable = ?", true).order(:position) }, dependent: :destroy
  has_many :templates, -> { where("ancestry IS NULL") }, class_name: "Section::Template"
  has_one :financial_section, -> { where(name: "form413") }, class_name: "Section"
  has_many :every_section_rule, class_name: "SectionRule"
  has_many :section_rules, -> { where(template_root_id: nil) }, dependent: :destroy
  has_many :section_rule_templates, -> { where("template_root_id IS NOT NULL") }, class_name: "SectionRule"

  has_many :answers, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :business_partners, dependent: :destroy
  has_many :sba_application_documents, dependent: :destroy
  has_many :documents, through: :sba_application_documents
  has_one :annual_report
  has_many :evaluation_histories, as: :evaluable
  has_many :ineligible_sba_applications, dependent: :destroy

  has_and_belongs_to_many :duty_stations

  validates :organization_id, presence: true
  validates :questionnaire_id, uniqueness: { scope: [:organization_id, :application_start_date] }
  validates :creator_id, presence: true, unless: :ignore_creator
  validate :validate_application, on: :create

  before_validation :set_start_date, on: :create
  before_validation :set_progress, on: :create
  before_validation :set_kind, on: :create
  before_validation :set_creator, on: :create

  after_create :copy_sections_and_rules, unless: :skip_copy_sections_and_rules
  after_create :create_hook

  before_destroy :destroy_contributors

  attr_accessor :current_user, :skip_copy_sections_and_rules, :contributor_id, :ignore_creator

  delegate :program, to: :questionnaire
  delegate :link_label, to: :questionnaire
  delegate :case_owner, to: :current_review

  def self.eight_a
    without_sub_apps
      .without_adhoc
      .joins(:certificate)
      .where("certificates.type" => Certificate::EightA)
  end

  def self.asmpp
    without_sub_apps
      .joins(:certificate)
      .where("certificates.type" => Certificate::ASMPP)
  end

  def self.has_bdmis_case
    where("bdmis_case_number IS NOT NULL")
  end

  def self.with_valid_cert
    joins(:certificate).where.not("certificates.workflow_state IN (?)", Certificate::EightA::NON_ACTIVE_STATES)
  end

  def self.not_in_review
    where("sba_applications.id NOT IN (SELECT sba_application_id FROM reviews WHERE deleted_at IS NULL AND certificate_id = certificates.id)")
  end

  def self.assigned_workload(user_id)
    u = User.find(user_id)
    is_cods_super = u.roles_map["CODS"].present? && u.roles_map["CODS"]["8a"][0] == "supervisor"

    if is_cods_super
      return joins(:reviews, :certificate)
               .where("sba_applications.id IN (SELECT sba_application_id FROM reviews WHERE deleted_at IS NULL AND certificate_id = certificates.id)")
               .where("((? IN (SELECT owner_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)) OR (? IN (SELECT reviewer_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)))", user_id, user_id)
               .where("sba_applications.workflow_state != 'pending_reconsideration_or_appeal'")
               .where("((reviews.workflow_state = 'pending_reconsideration_or_appeal' AND reviews.reconsideration_or_appeal_clock >= ?) or reviews.workflow_state <> 'pending_reconsideration_or_appeal')", (45.days.ago))
               .where("((reviews.workflow_state = 'pending_reconsideration' AND reviews.reconsideration_or_appeal_clock >= ?) or reviews.workflow_state <> 'pending_reconsideration')", (45.days.ago))
               .where.not("reviews.workflow_state IN (?)", CODS_NON_ACTIVE_STATES)
               .order(created_at: :asc).to_a +

               where("info_request_assigned_to_id = ? AND sba_applications.kind = ? AND sba_applications.workflow_state in (?)",
                     user_id, INFO_REQUEST, ACTIVE_STATES)
    else
      return joins(:reviews, :certificate)
               .where("sba_applications.id IN (SELECT sba_application_id FROM reviews WHERE deleted_at IS NULL AND certificate_id = certificates.id)")
               .where("((? IN (SELECT owner_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)) OR (? IN (SELECT reviewer_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)))", user_id, user_id)
               .where("sba_applications.workflow_state != 'pending_reconsideration_or_appeal'")
               .where("reviews.workflow_state != 'pending_reconsideration_or_appeal'")
               .where.not("reviews.workflow_state IN (?)", DISTRICT_NON_ACTIVE_STATES)
               .order(created_at: :asc).to_a +

               where("info_request_assigned_to_id = ? AND sba_applications.kind = ? AND sba_applications.workflow_state in (?)",
                     user_id, INFO_REQUEST, ACTIVE_STATES)
    end
  end

  def self.for_display
    without_sub_apps.without_adhoc.
      joins(:questionnaire).
      where("(kind = ? AND workflow_state IN (?)) OR (kind = ? AND workflow_state IN (?)) OR (kind = ? AND workflow_state IN (?)) OR (kind = ? AND workflow_state = ?)",
            INFO_REQUEST, ACTIVE_STATES,
            INITIAL, OPEN_STATES + ["complete"],
            ANNUAL_REVIEW, ACTIVE_STATES - ["submitted"],
            ANNUAL_REVIEW, "submitted")
  end

  def self.without_sub_apps
    where.not(type: "SbaApplication::SubApplication")
  end

  def self.without_adhoc
    where.not(kind: "adhoc")
  end

  def self.in_an_open_state
    where(workflow_state: OPEN_STATES)
  end

  def self.initial
    where(kind: INITIAL)
  end

  def self.annual_review
    where(kind: ANNUAL_REVIEW)
  end

  def is_really_a_review?
    false
  end

  def clear_servicing_bos
    certificate.clear_servicing_bos
  end

  def servicing_bos_name
    certificate.nil? ? "None" : certificate.servicing_bos_name
  end

  def duty_station_name
    certificate&.duty_station.nil? ? "None" : certificate&.duty_station.name
  end

  def duty_station_id
    certificate&.duty_station.nil? ? nil : certificate&.duty_station.id
  end

  def show_tabs?
    false
  end

  def linkable?
    return true if kind == INFO_REQUEST
    return false if (program.mpp? && draft?)
    !(program.eight_a? && draft?)
  end

  def is_open?
    OPEN_STATES.include? workflow_state
  end

  def is_adhoc?
    false
  end

  def sub_info_request?
    false
  end

  def returned?
    version_number != 1
  end

  # TODO make sure this is not used
  def is_under_reconsideration?
    # TODO has at least one reconsideration section, move to masterapplication subtype
    return true unless sections.map { |s| s.name }.grep(/reconsideration/).empty?
    return false
  end

  def info_request?
    kind == INFO_REQUEST
  end

  def is_wosb?
    %w(wosb edwosb).include?(self.certificate_type.name)
  end

  def is_initial?
    kind == INITIAL
  end

  def is_annual?
    kind == ANNUAL_REVIEW
  end

  def has_agi?
    questionnaire.has_agi?
  end

  def states
    "app_state=#{workflow_state} cert_state=#{certificate.try(:workflow_state)} review_state=#{current_review.try(:workflow_state)}"
  end

  def is_eight_a_master_application?
    self.is_a?(SbaApplication::MasterApplication)
  end

  def is_mpp_annual_report?
    kind == ANNUAL_REVIEW && program.name == "mpp" || questionnaire.mpp_annual_report?
  end

  def is_mpp_initial_complete?
    program.name == "mpp" && kind == "initial" && workflow_state == "complete"
  end

  def advance!(user, section, answer_params)
    SbaApplication::Progress.advance! self, user, section, answer_params
  end

  def not_in_appeal_or_complete?(current_user)
    return true if certificate&.finalized?
    return true if !in_appeal_or_complete?(current_user)
    false
  end

  def in_appeal_or_complete?(current_user)
    complete? && current_user.is_sba_or_ops?
  end

  def certificate
    if self.class.column_names.include?("certificate_id")
      Certificate.find_by(id: certificate_id)
    else
      Certificate.find_by(sba_application_id: id)
    end
  end

  def validate_application
    errors.add(:application, "already exists") unless valid_application?
  end

  def valid_application?(contributor = false)
    return true unless Organization::PROGRAM_NAMES.include? certificate_type.try(:name)

    return true if kind == ANNUAL_REVIEW && renewable?

    return true if kind == INITIAL && other_initial_master_apps_complete?

    # if we are a contributor we may have more than one sub_application of the same type for example multiple
    # biz partner or all the spouses of all the biz partners.
    if !contributor && !self.is_a?(SbaApplication::SubApplication)
      num_active_apps = SbaApplication.where(questionnaire_id: questionnaire_id, organization_id: organization_id, kind: kind, workflow_state: ACTIVE_STATES).size
      return num_active_apps + 1 <= questionnaire.maximum_allowed + number_of_expired_certificates
    else
      return true
    end
  end

  def existing_initial_master_apps
    SbaApplication.where(questionnaire_id: questionnaire_id, organization_id: organization_id, type: "SbaApplication::EightAMaster", kind: INITIAL)
  end

  def other_initial_master_apps_complete?
    existing_initial_master_apps.size > 0 && existing_initial_master_apps.all? { |master_application| master_application.workflow_state == "complete" }
  end

  def number_of_expired_certificates
    certificate_type.certificates.where(organization_id: organization_id, workflow_state: "expired").count
  end

  def certificate_type
    questionnaire.try(:certificate_type)
  end

  def link_to_section(status)
    status == Section::COMPLETE ? first_section : current_section || first_section
  end

  def new_review?
    is_eight_a_master_application? || is_mpp_annual_report?
  end

  def program
    questionnaire.program
  end

  def get_answerable_section_list(including = [])
    section_list = []

    get_applicable_sections.includes(including).each do |section|
      unless section.question_presentations.empty?
        section_list << section if section.is_a?(Section::QuestionSection)
      end
    end

    add_deferred_to_section_list section_list
  end

  def update_deferred!
    # You must call get_answerable_section_list to properly mark sections as applicable or non-applicable, this ultimately updates deferred sections as well
    get_answerable_section_list([:original_section])
  end

  def answered_every_section?
    section_list = get_answerable_section_list
    section_list.each do |section|
      unless section.is_completed
        #raise "A required section has not been completed for application ##{id} (#{section.name})"
        Rails.logger.warn("Application ##{id} does not have the #{section.name} completed")
        return false
      end
    end
    true
  end

  def unanswered_sections
    get_answerable_section_list.select { |section| !section.is_completed }
  end

  def update_skip_info!
    SbaApplication::Progress.new(self).update_skip_info! # for all the generated rules
  end

  def disqualify!
    get_answerable_section_list # if you don't do this you don't properly mark sections as applicable or non-applicable

    update_skip_info!
  end

  def update_parents!
    get_parents(root_section).reverse.each do |section|
      if section.children.reload.all? { |child| child.not_applicable? }
        section.update_attribute(:sub_sections_applicable, false)
      elsif section.children.reload.all? { |child| child.complete_or_na? }
        section.update_attribute(:sub_sections_applicable, true)
        section.update_attribute(:sub_sections_completed, true)
      else
        section.update_attribute(:sub_sections_applicable, true)
        section.update_attribute(:sub_sections_completed, false)
      end
    end
  end

  def get_section(section_id)
    sections.find(section_id)
  end

  def can_be_returned?
    return false if is_a? SbaApplication::MasterApplication # Use the new 8(a) return functionality for Master apps
    (submitted? || under_review?) && certificate && !certificate.technically_expired? && (certificate.active? || certificate.pending?) && organization.has_no_open_applications?(certificate_type)
  end

  def signature_section
    # NOTE: Assumes a single signature section per application...
    Section::SignatureSection.find_by(sba_application_id: id)
  end

  def has_financial_section?
    self.financial_section.nil? ? false : true
  end

  def current_review
    if certificate
      Review.find_by(certificate_id: certificate.id, sba_application_id: id)
    else
      nil
    end
  end

  def decision
    review = current_review
    case self.certificate_type.name
    when "wosb", "edwosb"
      case status
      when "Draft"
        ""
      when "Complete"
        review.determination.decision unless review.try(:determination).nil?
      else
        "self_certified"
      end
    when "mpp"
      case status
      when "Complete"
        review.determination.decision unless review.try(:determination).nil?
      else
        ""
      end
    end
  end

  def has_disqualifying_answers?
    !disqualified_questions.empty?
  end

  def disqualified_questions
    # we are assuming disqualifying questions cannot apply answers to dynamic questions... that is, ones where there is an associated "answered_for" model
    QuestionPresentation.disqualifiers_for(questionnaire_id).joins(question: :answers).select do |qp|
      qp.current_answer(self, nil).try(:disqualified?, qp)
    end
  end

  def is_reviewed?
    reviews.reload.any? { |review| review.persisted? }
  end

  def latest_review
    reviews.order(created_at: :desc).first
  end

  def renewable?
    return true unless kind == ANNUAL_REVIEW

    most_recent_certificate
  end

  def zip_file_exists?
    if Rails.env == "development" && !ENV.has_key?("AWS_S3_BUCKET_NAME")
      false
    else
      s3 = S3Service.new
      file_exists = s3.check_file_exists ENV["AWS_S3_BUCKET_NAME"], "#{self.organization.folder_name}/#{self.id}.zip"
      if file_exists
        self.zip_file_status >= 1
        save!
      end
      file_exists
    end
  end

  def destroy_contributors
    Contributor.where(sba_application: self).map { |c| c.revoke! }
  end

  # The person that fill out the application
  def get_vendor_applicant
    if answers.empty?
      organization.users.first
    else
      answers.first.owner
    end
  end

  # The analyst that owns the review.
  def get_current_analyst_owner
    current_review.try(:current_assignment).try(:owner)
  end

  # The analyst that performs the review currently
  def get_current_analyst_reviewer
    current_review.try(:current_assignment).try(:reviewer)
  end

  def vendor_admin_user
    organization.vendor_admidfn_user
  end

  def users
    organization.users
  end

  def current_users
    u = users.reject(&:is_contributor?) +
        users.where(id: self.contributors.pluck(:user_id)) +
        users.where(email: self.contributors.pluck(:email))
    u.uniq
  end

  def updates_needed?
    false
  end

  def has_active_certificate?
    return true if certificate && certificate.active?
    return true if certificate && certificate.pending?
    return true if certificate && certificate.ineligible?
    false
  end

  def create_hook; end

  def submit_hook; end

  def migrated_from_bdmis?
    self.bdmis_case_number.nil? ? false : true
  end

  protected

  def copy_sections_and_rules
    Section.transaction do
      copy_sections
      copy_section_rules
      update_skip_info!
    end
  end

  def set_start_date
    self.application_start_date = Time.now unless application_start_date?
  end

  def set_progress
    self.progress = { current: "" }
  end

  def set_kind
    self.kind = INITIAL if kind.blank? || kind == ENTITY_OWNED_INITIAL
  end

  def get_section_deferrers
    get_applicable_sections.where("terminal_section_id IS NOT NULL")
  end

  def get_parents(current_node, nodes = [])
    current_node.children.each do |node|
      if node.has_children?
        nodes = get_parents(node, nodes + [node])
      end
    end
    nodes
  end

  def remove_nonapplicable_answers_and_sections(current_user)
    sections.where({ is_applicable: false, is_completed: true }).each do |section|
      section.question_presentations.each do |qp|
        qp.answers.where(owner: current_user, sba_application_id: id).destroy_all
      end
    end
  end

  def copy_sections
    self.root_section = Section::Root.create!(master_root.cloned_attributes(self))

    copy_children(root_section)

    master_templates.each do |template|
      new_template = Section::Template.new(template.cloned_attributes(self))
      begin
        new_template.save!
        copy_children(new_template)
        sections.where(template_id: template.id).update_all template_id: new_template.id
      rescue Exception => e
        ExceptionNotifier.notify_exception(e)
      end
    end
    save!

    sections.where("defer_applicability_for_id IS NOT NULL").each do |section|
      deferrer = sections.find_by(original_section_id: section.defer_applicability_for_id)
      section.update_attribute(:defer_applicability_for_id, deferrer.id)
    end

    unless sections.empty? # to make tests pass...
      first_id = sections.find_by(original_section_id: master_first.id).try(:id)
      update_attribute(:first_section_id, first_id)
    end
  end

  def copy_children(parent)
    parent.original_section.children.order(:position).each do |original|
      attrs = original.cloned_attributes(self, parent)
      attrs["type"] = "Section::SubApplication" if attrs["type"] == "Section::SubQuestionnaire"
      new_section = sections.create!(attrs)

      copy_children(new_section) unless original.children.empty?
    end
  end

  def copy_section_rules
    master_rules.each do |original_rule|
      from_section = original_rule.from_section_id && every_section.find_by(original_section_id: original_rule.from_section_id)
      to_section = original_rule.to_section_id && every_section.find_by(original_section_id: original_rule.to_section_id)

      template_root_id = original_rule.template_root ? every_section.find_by(original_section_id: original_rule.template_root_id).try(:id) : nil

      # NOTE: terminal_section AND to_section are expected to be the same...
      section_rules.create! questionnaire: questionnaire, from_section: from_section, to_section: to_section, template_root_id: template_root_id, expression: original_rule.expression, is_last: original_rule.is_last, terminal_section: original_rule.is_multi_path_template ? to_section : nil, is_multi_path_template: original_rule.is_multi_path_template
    end
  end

  def get_applicable_sections
    sections.where(is_applicable: true, defer_applicability_for_id: nil).reorder("id asc")
  end

  def get_deferred_sections
    sections.where("defer_applicability_for_id IS NOT NULL")
  end

  def add_deferred_to_section_list(applicable_sections)
    get_deferred_sections.reverse.each do |section|
      deferrer = section.defer_applicability_for
      deferrer_index = applicable_sections.find_index(deferrer)

      unless deferrer_index
        section.update_attribute(:is_applicable, false)
        next
      end

      if !deferrer.is_completed? || deferrer.is_completed? &&
                                    section_rules.exists?(to_section_id: section.id)
        section.update_attribute(:is_applicable, true)
        applicable_sections.insert(deferrer_index + 1, section)
      else
        section.update_attribute(:is_applicable, false)
      end
    end

    update_parents!

    applicable_sections
  end

  def set_creator
    self.creator = current_user if current_user
  end
end
