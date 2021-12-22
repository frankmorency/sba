require "sba_application"

class SbaApplication::MasterApplication < SbaApplication
  include GeneralApplicationWorkflow

  belongs_to :note
  belongs_to :certificate
  has_many :sub_applications, class_name: "SbaApplication::SubApplication", foreign_key: :master_application_id, dependent: :destroy
  has_many :sub_application_sections, -> { (where(type: "Section::SubApplication")) }, class_name: "Section::SubApplication", foreign_key: :sba_application_id
  has_many :contributors, foreign_key: :sba_application_id, dependent: :destroy

  after_create :create_sub_apps

  def self.unassigned_cases
    where(kind: SbaApplication::INITIAL).where(bdmis_case_number: nil).not_in_review.with_valid_cert.order("created_at ASC")
  end

  def self.do_supervisor_assigned_cases(user)
    eight_a.with_valid_cert.assigned_workload(user.id)
  end

  def self.do_supervisor_unassigned_cases(user)
    eight_a.
      has_bdmis_case.not_in_review.with_valid_cert.
      joins(:duty_stations).where("duty_stations.id" => user.duty_stations.map(&:id)).
      order(created_at: :asc)
  end

  def show_tabs?
    true
  end

  # Need to overide this to make sure @certificate.save! does not poop the party...
  def create_certificate!
    transaction do
      @certificate = Certificate.factory(organization: organization, certificate_type: questionnaire.certificate_type)
      @certificate.save!
      update_attribute(:certificate_id, @certificate.id)
    end
  end

  def in_appeal_or_complete?(current_user)
    super || in_appeal?
  end

  def tags
    case questionnaire.name
    when "eight_a_migrated", "eight_a_annual_review", "eight_a_info_request"
      return ["BOS Analysis", "Adverse Action", "Business Development", "Control", "Eligibility", "Letter of Intent", "Ownership", "Retain Firm", "Review Complete"].map { |name| Tag.find_by_name(name) }
    when "eight_a_initial", "entity_owned_initial"
      return ["BOS Analysis", "Control", "Character", "Eligibility", "Ownership", "Potential for Success"].map { |name| Tag.find_by_name(name) }
    else
      return nil
    end
  end

  def drafty?
    draft? || returned?
  end

  def returned_with_letter?
    returned? && current_review.try(:returned_with_15_day_letter?)
  end

  def advance!(user, section, answer_params)
    SbaApplication::MasterApplication::Progress.advance! self, user, section, answer_params
  end

  def master_application_section
    every_section.find_by(type: "Section::MasterApplicationSection")
  end

  def adhoc_section_root
    master_application_section.children.find_by(type: "Section::AdhocQuestionnairesSection")
  end

  def reconsideration_section_root
    master_application_section.children.find_by(type: "Section::ReconsiderationSection")
  end

  def has_reconsideration_sections?
    master_application_section.children.where(type: "Section::ReconsiderationSection").count > 0
  end

  def all_reconsiderations_complete?
    master_application_section.children.where(type: "Section::ReconsiderationSection").all? { |section| section.app_complete? }
  end

  def last_reconsideration_section
    master_application_section.children.where(type: "Section::ReconsiderationSection").order(position: :asc).last
  end

  def last_reconsideration_application
    last_reconsideration_section&.sub_application
  end

  def submitted_reconsideration?
    has_reconsideration_sections? && submitted? && last_reconsideration_application&.submitted? && current_review.processing?
  end

  def awaiting_reconsideration_submission?
    return false unless has_reconsideration_sections?
    return false if submitted? && last_reconsideration_application&.submitted?
    return true if ["pending_reconsideration", "pending_reconsideration_or_appeal", "appeal_intent"].include?(current_review.workflow_state)
    return true if ["reconsideration"].include?(current_review.workflow_state) && !submitted?
    false
  end

  def show_signature_section?
    return true if info_request? && !submitted?
    !submitted? && !complete?
  end

  def has_reconsideration_sections_and_ineligible_certificate?
    certificate && certificate.ineligible? && has_reconsideration_sections?
  end

  def can_be_submitted?
    master_application_section.sections_for_submission_check.all? { |section| section.app_complete? }
  end

  def prerequisites_complete?
    sub_application_sections.prerequisite.where("status != ?", Section::COMPLETE).count == 0
  end

  def sections_for_tags
    first_section.children.where.not(type: ["Section::AdhocQuestionnairesSection", "Section::ContributorSection"])
  end

  def vendor_admin_user
    organization.vendor_admin_user
  end

  def all_documents(user_id_value = nil, is_active_value = true, is_analyst_value = false)
    documents = []
    adhoc_applications = organization.sba_applications.where(master_application_id: self.id, kind: "adhoc")
    # Add documents attached to master application and adhoc applications
    if user_id_value.nil?
      documents << self.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value)
      adhoc_applications.each do |app|
        documents << app.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value)
      end
    else
      documents << self.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value).where(user_id: user_id_value)
      adhoc_applications.each do |app|
        documents << app.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value).where(user_id: user_id_value)
      end
    end
    self.first_section.children.each do |section|
      if section.is_a?(Section::ContributorSection) && section.has_children?
        section.children.each do |sub_section|
          if sub_section.has_children?
            sub_section.children.each do |contributor_section|
              unless (contributor_section.nil? || contributor_section.sub_application.nil? || contributor_section.sub_application.documents.size < 1)
                # add documents attached to contributor sub_application
                if user_id_value.nil?
                  documents << contributor_section.sub_application.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value)
                else
                  documents << contributor_section.sub_application.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value).where(user_id: user_id_value)
                end
              end
            end
          end
        end
      else
        unless (section.sub_application.nil? || section.sub_application.documents.size < 1)
          # add documents attached to other subapplication
          if user_id_value.nil?
            documents << section.sub_application.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value)
          else
            documents << section.sub_application.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value).where(user_id: user_id_value)
          end
        end
      end
    end
    documents.flatten!.uniq
  end

  def app_overview_title
    "Application Overview"
  end

  def updates_needed?

    # logic to pause application
    review = Review::EightA.find_by(certificate_id: self.certificate_id)
    if review && review.type == "Review::EightAInitial"
      if (unanswered_adhoc_reviews > 0 || (info_request? && OPEN_STATES.include?(workflow_state))) && review.workflow_state == "processing"
        review.send(:pause_processing) unless review.processing_paused?
      elsif review.processing_paused?
        review.send(:resume_processing)
      end
    end

    unanswered_adhoc_reviews > 0 || (info_request? && OPEN_STATES.include?(workflow_state))
  end

  def assign_duty_station_to_app(duty_station)
    duty_stations.clear
    duty_stations << duty_station
    self.ignore_creator = true
    save!

    assign_duty_station_to_certificate duty_station
  end

  def assign_duty_station_to_certificate(duty_station)
    certificate.duty_station = duty_station
    certificate.save!
  end

  def assign_servicing_bos_to_certificate(servicing_bos)
    certificate.servicing_bos = servicing_bos
    certificate.save!
  end

  def submit_hook
    # 8(a) Initial Application Screening due - 15 days from time of submissison
    self.screening_due_date = 15.days.from_now.to_date
  end

  def decision
    return "Declined" if current_review && current_review.appeal?
    return "Declined" if current_review && current_review.appeal_intent?
    return "Declined" if current_review && current_review.reconsideration?
    return "Declined" if current_review && current_review.pending_reconsideration?
    return "Declined" if current_review && current_review.pending_reconsideration_or_appeal?
    return "Declined" if current_review && current_review.sba_declined?
    return "Declined" if current_review&.closed_automatically?
    return "Retained" if current_review && current_review.workflow_state == "retained"
  end

  def card_title(section)
    if section.is_a?(Section::ReconsiderationSection) && current_review && last_reconsideration_section.id == section.id
      return "Reconsideration or Appeal" if current_review.pending_reconsideration_or_appeal?
      return "Intent to Appeal" if current_review.appeal_intent?
      return "Appeal" if current_review.appeal?
    end
    section.title
  end

  def answer_title(section)
    if section.is_a?(Section::ReconsiderationSection) && current_review && last_reconsideration_section.id == section.id
      return "Reconsideration or Appeal" if current_review.pending_reconsideration_or_appeal?
      return "Intent to Appeal" if current_review.appeal_intent?
      return "Appeal" if current_review.appeal?
    end
    section.title
  end

  def in_last_reconsideration_section_during_appeal?(section)
    has_reconsideration_sections? && last_reconsideration_section.id == section.id && current_review && current_review.appeal?
  end

  def in_appeal?
    workflow_state == "draft" && current_review&.workflow_state == "appeal"
  end

  private

  def create_sub_apps
    sub_application_sections.each do |section|
      unless section.sub_questionnaire
        raise "No subquestionnaire for section: #{section.inspect}"
      end
      app = section.sub_questionnaire.start_application organization,
                                                        master_application: self,
                                                        master_section: master_application_section,
                                                        kind: kind,
                                                        creator_id: creator_id
      app.ignore_creator = ignore_creator
      app.save!
    end
  end
end
