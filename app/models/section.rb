class Section < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  has_ancestry

  STATUSES = ["NOT STARTED", "IN PROGRESS", "INVITATION EXPIRED", "COMPLETE"] unless defined? STATUSES
  NOT_STARTED, IN_PROGRESS, INVITATION_EXPIRED, COMPLETE = STATUSES unless defined? NOT_STARTED

  belongs_to :questionnaire
  belongs_to :sba_application
  belongs_to :application_version, class_name: "SbaApplication"
  belongs_to :answered_for, polymorphic: true
  belongs_to :original_section, class_name: "Section"
  belongs_to :template, class_name: "Section::Template"
  belongs_to :defer_applicability_for, class_name: "Section"

  has_many :question_presentations, -> { order(:position) }, dependent: :destroy
  has_many :questions, through: :question_presentations
  has_many :section_rule_origins, class_name: "SectionRule", foreign_key: :from_section_id
  has_many :section_rule_destinations, class_name: "SectionRule", foreign_key: :to_section_id
  has_many :assessments, -> { order(created_at: :desc) }, as: :the_assessed
  has_many :adhoc_sections, -> { order(created_at: :desc) }, class_name: "Section::SubApplication", foreign_key: :related_to_section_id

  has_many :reconsideration_sections, -> { order(created_at: :desc) }, class_name: "Section::ReconsiderationSection"

  attr_accessor :assessment_accessor, :assessments_accessor

  attr_reader :current_application, :current_organization, :user

  validate :has_template, if: :dynamic?
  before_validation :set_submit_text, on: :create
  before_validation :set_status, on: :create

  validates :name, presence: true, uniqueness: { scope: [:questionnaire_id, :sba_application_id, :deleted_at] }
  validates :title, presence: true

  def self.customize_name(section_name, partner_name)
    "#{section_name}_#{partner_name.gsub(/\W+/, "").split.map(&:underscore).join("_")}"
  end

  def self.old_customize_name(section_name, partner_name)
    "#{section_name}_#{partner_name.split.map(&:underscore).join("_")}"
  end

  def is_dvd_vendor?
    name == "contributor_va_eight_a_disadvantaged_individual"
  end

  def is_dvd_spouse?
    name =~ /^eight_a_spouse_/
  end

  def is_dvd_contributor?
    name =~ /^eight_a_disadvantaged_individual_/
  end

  def is_dvd_partner?
    name =~ /^eight_a_business_partner_/
  end

  def status_style
    status && status.downcase.split.join("_")
  end

  def email
    description.count("@") > 0 ? description : nil if description
  end

  def self.get(name)
    find_by(name: name.to_s)
  end

  def underscore_type
    self.class.to_s.demodulize.underscore.pluralize
  end

  def not_started?
    status == NOT_STARTED
  end

  def app_complete?
    status == COMPLETE
  end

  def for_app(app)
    if sba_application_id
      self
    else
      Section.find_by(original_section_id: id, sba_application_id: app.id)
    end
  end

  def defer_applicability_for=(name)
    return if name.blank?

    if sba_application
      super(sba_application.sections.find_by(name: name))
    elsif questionnaire
      super(questionnaire.sections.find_by(name: name))
    end
  end

  def customize_name(value)
    self.class.customize_name(name, value)
  end

  def old_customize_name(value)
    self.class.old_customize_name(name, value)
  end

  def cloned_attributes(app, parent = nil)
    attributes.with_indifferent_access.merge(is_applicable: is_applicable, sba_application_id: app.id, original_section_id: id, parent: parent).except(:id, :created_at, :updated_at)
  end

  def complete?
    if children.empty?
      is_completed
    else
      sub_sections_completed
    end
  end

  def applicable?
    if children.empty?
      is_applicable
    else
      sub_sections_applicable
    end
  end

  def complete_or_na?
    if children.empty?
      is_completed || !is_applicable
    else
      sub_sections_completed || !sub_sections_applicable
    end
  end

  def not_applicable?
    !applicable?
  end

  # Arrangement to nested array
  def self.arrange_for_display(with_ids, nodes = nil)
    nodes = arrange(order: :position) if nodes.nil?
    nodes.map do |parent, children|
      parent.display_columns(with_ids).merge children: arrange_for_display(with_ids, children)
    end
  end

  def self.dynamic
    where(dynamic: true)
  end

  def self.without_parent
    where(ancestry: nil)
  end

  def self.displayable
    where(displayable: true)
  end

  def class_path
    self.class.to_s.split("::").last.underscore.pluralize
  end

  def to_param
    name
  end

  def question_presentations
    return super unless sba_application_id && (original_section_id || dynamic?)

    dynamic? ? template.question_presentations : original_section.question_presentations
  end

  def questions
    return super unless sba_application_id && (original_section_id || dynamic?)

    dynamic? ? template.questions : original_section.questions
  end

  def add_question(eval_purpose, question, position, positive_response = nil, helpful_info)
    question.applicable_questions.new positive_response: positive_response, evaluation_purpose: eval_purpose
    presentation = question.question_presentations.new section: self, position: position, helpful_info: helpful_info
    question.save!
    presentation
  end

  def next_section(user, app_id)
    next_section, skip_info = nil, nil

    section_rule_list = get_section_rule_list(app_id, user)

    section_rule_list.each do |rule|
      if move_on?(rule, app_id)
        next_section = current_application.get_section(rule.to_section_id)
        if rule.is_multi_path_template
          # update the skip info for the original multi-path rule
          # (to include all sections available from here)
          skip_info = Evaluator::MultiPath.new(rule, rule.expression, sba_application.id).update_skip_info!
        else
          skip_info = rule.skip_info
        end

        break
      end
    end unless section_rule_list.empty?

    [next_section, skip_info]
  end

  def get_section_rule_list(app_id, user)
    @user, @application_id = user, app_id

    # TODO: Ensure the app is in one of the user's orgs
    @current_application ||= SbaApplication.find(app_id)
    @current_organization = @current_application.organization

    @current_application.section_rules.where(from_section_id: id)
  end

  def update_progress(answer_params, sba_application)
  end

  def arrangement(with_ids = true)
    subtree.arrange_for_display(with_ids)
  end

  def to_html
    return <<-EOF
        <li>
          <b>#{title}</b> #{section_rule_origins.map(&:debug).join(" | ")}
          #{children.empty? ? "" : "<ul>#{children.order(position: "asc").map { |child| child.to_html }.join()}</ul>"}
        </li>
    EOF
  end

  def to_s
    "#{"|" if ancestry}#{"__" * (ancestry ? (ancestry.scan(/\//).count + 1) : 0)}#{title}\n#{children.order(position: "asc").each { |child| child.to_s }.join("\n")}"
  end

  def move_on?(rule, app_id)
    move_on = true
    if rule.expression.kind_of?(Array)
      rule.expression.each do |sub_expression|
        move_on = move_on && Evaluator.eval_expression(rule, sub_expression, app_id)
      end
    else
      move_on = move_on && Evaluator.eval_expression(rule, rule.expression, app_id)
    end
    move_on
  end

  def display_columns(with_ids)
    cols = {
      name: name,
      title: title,
      position: position,
      type: type.split("::").last.underscore,
    # sub_questionnaire_id: sub_questionnaire_id,
    # sub_application_id: sub_application_id
    }

    if with_ids
      cols.merge! questionnaire_id: questionnaire_id, sba_application_id: sba_application_id
    end

    cols
  end

  def toggle_json
    toggle = {}
    validation_rules["toggle"].each do |primary, details|
      toggle["input[name='answers[#{qp_id_for_question primary}][value]']"] = {
        div: "#answers_#{details["dependent"]}",
        show_on: details["show_on"],
        input: "#answers_#{qp_id_for_question details["dependent"]}_value",
      }
    end unless validation_rules.blank?
    toggle.to_json
  end

  def is_viewable?
    self.is_a?(Section::ApplicationSection) || self.is_a?(Section::PersonalSummary) || self.is_a?(Section::PersonalPrivacy)
  end

  def qp_id_for_question(name)
    question_presentations.where(question_id: Question.id_for(name)).take.id
  end

  def set_sub_q_status
    self.status = Section::NOT_STARTED if Section.column_names.include?("status")
  end

  private

  def set_submit_text
    self.submit_text = "Save & Continue" unless submit_text
  end

  def set_non_displayable
    if respond_to?(:displayable)
      self.displayable = false
      nil
    end
  end

  def set_status
    self.is_completed = false unless is_completed
    self.is_applicable = true if is_applicable.nil?
  end

  def has_template
    if dynamic? && !template
      errors.add :template, "must be provided for dynamic sections"
    end
  end
end

require_relative "section/personal_summary"
