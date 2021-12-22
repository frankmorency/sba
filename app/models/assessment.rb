class Assessment < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :review
  belongs_to :the_assessed, polymorphic: true
  belongs_to :assessed_by, class_name: "User"

  belongs_to :note

  STATUSES = ["Confirmed", "Not reviewed", "Information missing", "Makes vendor ineligible", "Needs further review"]

  ALL_STATUSES = STATUSES + Review.workflow_spec.state_names.map(&:to_s)

  validates :status, presence: true, inclusion: { in: ALL_STATUSES }
  validates :the_assessed, presence: true
  validates :the_assessed_type, inclusion: %w(Section Answer Review)

  validates :assessed_by, presence: true
  validate :assessed_by_analyst

  before_validation :set_status, on: :create

  def note_body
    note.try(:body)
  end

  def note_body=(text)
    unless text.blank?
      build_note(body: text, published: true)
    end
  end

  def short?
    note.nil? || note.short?
  end

  def display_status
    Review.status_label(status)
  end

  protected

  def set_status
    return if the_assessed.is_a?(Review)
    unless status || !the_assessed
      self.status = the_assessed.assessments.first.try(:status)
    end
  end

  def assessed_by_analyst
    unless assessed_by.can? :manage_assessment, assessed_by
      errors.add(:assessed_by, "must be an sba analyst")
    end
  end
end
