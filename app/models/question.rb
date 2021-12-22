class Question < ActiveRecord::Base
  include NameRequirements

  acts_as_paranoid
  has_paper_trail

  belongs_to :question_type
  has_many :answers
  has_many :question_presentations, dependent: :destroy
  has_many :applicable_questions, dependent: :destroy
  has_many :question_rules, through: :question_type
  has_many :document_type_questions
  has_many :document_types, through: :document_type_questions

  alias_method :rules, :question_rules

  def self.make!(question_type_name, name, title)
    question = new
    question.question_type = QuestionType.find_by(name: question_type_name)
    question.title = title
    question.name = name
    question.save!
    question
  end

  def self.id_for(name)
    find_by(name: name).id
  end

  def current_answer(sba_app, answered_for, prepopulate_for = nil)
    answer = answers.set_for(sba_app, answered_for).order(created_at: :desc).limit(1).first
    return answer unless prepopulate_for && prepopulate && answer.nil?

    answers.where(answered_for: answered_for, owner: prepopulate_for).order(created_at: :desc).limit(1).first
  end

  def sub_questions
    read_attribute(:sub_questions).map { |q| SubQuestion.from_json(q) }.sort_by { |q| q.position } unless read_attribute(:sub_questions).blank?
  end

  def unique_id
    id
  end

  def ==(other)
    unique_id == other.unique_id
  end
end
