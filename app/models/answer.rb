class Answer < ActiveRecord::Base
  include QuestionProxy
  include Versionable

  OUTCOMES = %w(incomplete success failure maybe).map(&:to_sym)
  INCOMPLETE, SUCCESS, FAILURE, MAYBE = OUTCOMES

  acts_as_paranoid
  has_paper_trail

  belongs_to :question
  belongs_to :owner, polymorphic: true
  belongs_to :answered_for, polymorphic: true

  has_many :answer_documents
  has_many :documents, through: :answer_documents
  has_many :assessments, -> { order(created_at: :desc) }, as: :the_assessed

  attr_accessor :explanations, :question_text, :brand_new_answered_for_ids

  validates :question_id, presence: true

  def self.set_for(app, model = nil)
    where(sba_application: app, answered_for: model)
  end

  def disqualified?(question_presentation)
    return false unless question_presentation.disqualifier.present?
    value && value["value"] == question_presentation.disqualifier.value
  end

  def self.blank_explanations
    { failure: [], maybe: [], incomplete: [], success: [] }
  end

  def value_as_date(val = display_value)
    val.blank? ? "" : (Chronic.parse(val).try(:to_date) || "")
  end

  def date_range_from
    value_as_date(value["value"]["start_date"])
  end

  def date_range_to
    value_as_date(value["value"]["end_date"])
  end

  def display_value(val = "value")
    return nil unless value
    val == "value" ? value[val] : value["value"][val]
  end

  def question_type=(qt)
    @question_type = qt
  end

  def question_type
    return @question_type if @question_type

    super
  end

  def casted_value
    question_type.cast display_value
  end

  def to_s
    "[#{owner.first_name} #{sba_application.id} #{answered_for.try(:name)}] #{question.try(:title)}: #{display_value}"
  end
end
