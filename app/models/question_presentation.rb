class QuestionPresentation < ActiveRecord::Base
  include QuestionProxy
  include Searchable

  searchable fields: {
    "Name" => "questions.name",
    "Title" => "questions.title",
    "Type" => "question_types.name",
  }, default: "Name", per_page: 10

  acts_as_paranoid
  has_paper_trail

  belongs_to :question
  belongs_to :section
  belongs_to :disqualifier

  attr_accessor :value, :comment, :details, :documents, :assessment, :assessments

  delegate :answers, to: :question
  delegate :possible_values, to: :question
  delegate :multi, to: :question
  delegate :current_answer, to: :question
  delegate :title_wrapper_tag, to: :question

  attr_accessor :answered_for_id, :answered_for_type

  def self.get(name)
    joins(:question).find_by("questions.name = ?", name)
  end

  def self.get_decider(name)
    joins(:question).where("questions.name = ?", name).first
  end

  def self.disqualifiers_for(questionnaire_id)
    # work around for http://stackoverflow.com/questions/23509740/distinct-on-postgresql-json-data-column
    joins(:section).where("disqualifier_id IS NOT NULL AND sections.questionnaire_id = ? and sections.sba_application_id IS NULL", questionnaire_id).select("DISTINCT ON (question_presentations.id) question_presentations.*")
  end

  def display_title(sba_app = nil)
    if sba_app
      sba_app.is_adhoc? || sba_app.sub_info_request? ? sba_app.adhoc_question_title : title
    elsif section.questionnaire.is_adhoc?
      section.questionnaire.adhoc_question_title || title
    else
      title
    end
  end

  def name_with_index
    name
  end

  def sub_questions
    question.sub_questions.map { |q| q.id = id; q }
  end

  def dom_id(type = "value")
    "answers[#{id}][#{type}]"
  end

  def type_name
    question.question_type.name
  end

  def positive_response_for(evaluation_purpose_name)
    ApplicableQuestion.find_by(question_id: unique_id, evaluation_purpose_id: EvaluationPurpose.get(evaluation_purpose_name).id).positive_response
  end

  def title
    question_override_title.blank? ? question.title : question_override_title
  end

  def failure_message
    helpful_info && helpful_info["failure"] || "Something went terribly wrong"
  end

  def maybe_message
    helpful_info && helpful_info["maybe"] || "We're just not sure about this"
  end

  def not_required?
    return true if validation_rules && !validation_rules[:required]
    false
  end

  def is_disqualifying?
    disqualifier
  end

  def has_disqualifier?
    respond_to?(:disqualifier) && disqualifier.present?
  end
end
