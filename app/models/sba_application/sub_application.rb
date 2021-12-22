require 'sba_application'

class SbaApplication::SubApplication < SbaApplication
  include SubApplicationWorkflow
  include GeneralApplicationWorkflow
  include NotificationsHelper

  RECONSIDERATION_AND_APPEAL_RESPONSE_DEADLINE = 45.days
  UNABLE_TO_SUBMIT_RECONSIDERATION_OR_APPEAL_MESSAGE = 'You can no longer submit your appeal or reconsideration since 46 or more days have passed.'

  validates     :master_application_id, presence: true
  #validates    :position, presence: true, uniqueness: { scope: :master_application_id }

  attr_accessor :master_section

  after_create  :link_to_contributor, if: :contributor_id
  after_create  :link_to_master_section

  def certificate_type
    master_application_id && master_application.certificate_type
  end

  # This is necessary because master app can be either MasterApplication or an EightAAnnualReview...
  def master_application
    SbaApplication.find(master_application_id)
  end

  def master_application=(app)
    self.master_application_id = app.id
  end

  def kind
    read_attribute(:kind) || master_application_id && master_application.try(:kind)
  end

  def not_submitted_but_complete?(section)
    application_submitted_at.nil? && section.app_complete?
  end

  def is_adhoc?
    kind == SbaApplication::ADHOC
  end

  def sub_info_request?
    kind == SbaApplication::INFO_REQUEST
  end

  def is_reconsideration?
    kind == SbaApplication::RECONSIDERATION
  end

  def reconsideration_or_appeal_deadline_passed?
    appeal_clock = current_review&.reconsideration_or_appeal_clock
    return false unless current_review
    return false if appeal_clock > DateTime.new(2018, 11, 6) && appeal_clock < DateTime.new(2018, 12, 23) # Gov shutdown exception APP-4291
    return false if Date.today < appeal_clock + RECONSIDERATION_AND_APPEAL_RESPONSE_DEADLINE
    true
  end

  def decision
    ''
  end

  def current_review
    master_application.current_review
  end

  def appeal_intent_selected
  end

  def is_blocked_from_starting?
    questionnaire.title == "Reconsideration Questionnaire" && self.appeal_intent_selected?
  end

  def create_hook
    if is_adhoc?
      master_application.update_attribute :unanswered_adhoc_reviews, master_application.unanswered_adhoc_reviews + 1
    end
  end

  def submit_hook
    if is_adhoc?
      master_application.update_attribute :unanswered_adhoc_reviews, master_application.unanswered_adhoc_reviews - 1
    end

    if is_reconsideration?
      ApplicationController.helpers.log_activity_application_state_change('resubmitted_section', master_application_id, current_user.id, self.id) if Feature.active?(:activity_log)
      Section.where(sub_application_id: id).where(type: 'Section::ReconsiderationSection').take.update_attribute(:status, Section::COMPLETE)
      current_review.user_submit_reconsideration!
    end
  end

  def drafty?
    if complete?
      reopen!
    end

    true
  end

  # are we using the section status or the workflow state?????
  def complete?
    status == Section::COMPLETE
  end

  def reopen!(contributor=false)
    unless contributor
      section.update_attribute(:status, Section::IN_PROGRESS)
      update_attribute :current_section, nil
      super
    end
  end

  def submit
    transaction do
      submit_without_certificate(false)
      all_sections.update_all(status: Section::COMPLETE)
      if is_adhoc?
        reviewer = master_application.returned_reviewer
        reviewer = master_application.current_review.current_assignment.reviewer if reviewer.nil?
        send_application_adhoc_questionnaire_responded(master_application.kind, kind, reviewer.id, id, reviewer.email, organization.name)
      elsif sub_info_request?
        assigned_to = User.find_by_id(master_application.info_request_assigned_to_id)
        if assigned_to
          send_application_info_responded("8(a)", "participation", assigned_to.id, master_application.id, assigned_to.email, organization.name)
        end
        ApplicationController.helpers.log_activity_application_state_change('adhoc_submitted', master_application.id, current_user.id)
      end
    end

    nil
  end

  def all_sections
    master_application.sections.where(sub_application_id: id) ||
        master_application.sub_application_sections.where(name: questionnaire.name)
  end

  def section
    master_application.sections.find_by(sub_application_id: id) ||
        master_application.sub_application_sections.find_by(name: questionnaire.name)
  end

  # The analyst that owns the review.
  def get_current_analyst_owner
    master_application.get_current_analyst_owner
  end

  # The analyst that performs the review currently
  def get_current_analyst_reviewer
    master_application.get_current_analyst_reviewer
  end

  def current_responsible_party
    if master_application_id && master_application.returned?
      'Firm'
    elsif submitted?
      'SBA'
    else
      'Firm'
    end
  end

  protected

  def link_to_contributor
    unless contributor_id.blank?
      Contributor.find(contributor_id).update_attribute(:sub_application_id, id)
    end
  end

  def link_to_master_section
    return if is_adhoc? || is_reconsideration?

    # CONSIDER QUESTIONNAIRE VERSIONING HERE

    if ! contributor_id.blank?
      master_application.sections.find_by(name: 'disadvantaged_individuals').descendants.find_by(description: Contributor.find(contributor_id).email).update_attribute(:sub_application_id, id)
      # vendor admin
    elsif questionnaire.initial_or_annual_dvd?
      sec = master_application.sub_application_sections.find_by(name: 'contributor_va_eight_a_disadvantaged_individual')
      sec.update_attribute(:sub_application_id, id) if sec.parent.name == 'vendor_admin'
    elsif kind == INFO_REQUEST
      Section::SubApplication.create! parent: master_section.children.find_by(name: 'adhoc_questions'),
                                      name: "adhoc_questionnaire_#{id}", questionnaire: master_application.questionnaire,
                                      sba_application: master_application, title: questionnaire.title,
                                      sub_application: self, sub_questionnaire: questionnaire
    else # normal case
      unless section # need to check all these cases
        master_section.update_attribute(:sub_application_id, id)
      end

      section.update_attribute(:sub_application_id, id)
    end
  end
end