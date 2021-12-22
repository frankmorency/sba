class Review < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index("cases_v2#organization") do
      certificate.organization if certificate
    end
    # Old index, remove when UI is retired
    #update_index('cases#certificate') { certificate }
  end

  include WorkflowWithHistory
  include ReviewWorkflow
  include Versionable

  REVIEW_TYPES = {
    "Review::Initial" => "Initial Review",
  }

  acts_as_paranoid
  has_paper_trail

  belongs_to :certificate
  belongs_to :sba_application
  belongs_to :current_assignment, class_name: "Assignment"
  belongs_to :determination, autosave: true, dependent: :destroy

  has_many :assignments, -> { order(updated_at: "desc") }, dependent: :destroy
  has_many :assessments, -> { order(created_at: "desc") }, as: :the_assessed, dependent: :destroy
  has_many :review_documents, dependent: :destroy
  has_many :documents, through: :review_documents
  has_many :evaluation_histories, as: :evaluable

  accepts_nested_attributes_for :current_assignment

  before_validation :set_case_number, on: :create

  validates :workflow_state, presence: true
  validates :case_number, uniqueness: true, presence: true
  validates :certificate, presence: true

  scope :pending_reconsideration_or_appeal, -> { where(workflow_state: "pending_reconsideration_or_appeal") }

  def self.factory(attrs)
    type = attrs.delete(:type)
    raise "Invalid Review Type" unless REVIEW_TYPES.keys.include?(type)

    type.constantize.new(attrs)
  end

  def is_really_a_review?
    false
  end

  def organization
    sba_application.organization
  end

  def is_out_of_cycle?
    false
  end

  def reviewer
    return current_assignment.reviewer if current_assignment
    nil
  end

  def case_owner
    return current_assignment.owner if current_assignment
    nil
  end

  # def case_assignee
  #   return current_assignment.owner if current_assignment
  #   nil
  # end

  def refer_to_new_reviewer(user, business_unit)
    transaction do
      new_assignment = assignments.order(created_at: :desc).first.dup
      new_assignment.reviewer = user
      assignments << new_assignment
      save!
      self.current_assignment = new_assignment.reload
      save!

      if respond_to?(:pause_conditions) && pause_conditions(business_unit)
        pause_processing
      end

      if respond_to?(:resume_conditions) && resume_conditions(business_unit)
        resume_processing
      end
    end
  end

  def recommend(req)
    self.recommend_eligible = req.recommend_eligible
    self.recommend_eligible_for_appeal = req.recommend_eligible_for_appeal
    save!
    refer_to_new_owner_and_reviewer(req.individual)
  end

  def refer_to_new_owner_and_reviewer(user)
    transaction do
      new_assignment = assignments.order(created_at: :desc).first.dup
      new_assignment.reviewer = user
      new_assignment.owner = user
      assignments << new_assignment
      save!
      self.current_assignment = new_assignment.reload
      save!
    end
  end

  def update_determination!(user, selected_review_state, original_reviewer_id, reviewer_id, determination_attrs, note_attrs)
    Review.transaction do
      if note_attrs[:note_body]
        self.assessments.create!(
          note_attrs.merge(
            review_id: id,
            status: workflow_state,
            assessed_by: user,
            determination_decision: determination_made? ? determination.decision.try(:titleize) : nil,
          )
        )
      end

      if determination
        determination.update_attributes(
          decision: determination_attrs[:decision].to_i,
          decider_id: determination_attrs[:decider_id],
        )
      elsif determination_attrs[:decision]
        create_determination!(
          decision: determination_attrs[:decision].to_i,
          decider_id: determination_attrs[:decider_id],
        )
      elsif selected_review_state == "returned_for_modification"
        if sba_application.can_be_returned?
          sba_application.return_for_modification
          return_for_modification!
        else
          raise "Cannot return an application when there is already a draft"
        end
        return
      end

      event = get_event_for_review_state(selected_review_state)
      send_event! self, event

      if original_reviewer_id != reviewer_id
        current_assignment.update_columns(reviewer_id: reviewer_id)
        self.assessments.create!(
          note_attrs.merge(
            review_id: id,
            new_reviewer_id: reviewer_id,
            status: workflow_state,
            assessed_by: user,
            determination_decision: determination_made? ? determination.decision.try(:titleize) : nil,
          )
        )
      end
      save!
    end
  end

  def reset
    Review.transaction do
      self.current_assignment.destroy if self.current_assignment
      Assessment.where(review_id: self.id).destroy_all
      self.cancel!
      self.destroy!
    end
  end

  def to_param
    case_number
  end

  def display_type
    REVIEW_TYPES[type.to_s]
  end

  def vendor_status
    if status =~ /\ARecommend\s+/
      "Assigned In Progress"
    else
      status
    end
  end

  def get_event_for_review_state(review_state)
    if review_state == "determination_made"
      DECISION_TO_EVENT[determination.decision]
    else
      STATE_TO_EVENT[review_state]
    end
  end

  def next_due_date
    if processing_paused
    end
  end

  def display_status
    self.class.status_label(workflow_state)
  end

  def self.status_label(review_state)
    STATE_LABELS[review_state]
  end

  def certificate_type_name
    sba_application.certificate_type.name if sba_application.certificate_type
  end

  def sba_application_has_financial_section?
    certificate.current_application.has_financial_section? if certificate.current_application
  end

  def program
    certificate.program.name
  end

  def kind_label
    sba_application.display_kind
  end

  def current_owner
    if current_assignment
      current_assignment.owner
    else
      return nil
    end
  end

  def current_reviewer
    if current_assignment
      current_assignment.reviewer
    else
      return nil
    end
  end

  def user_is_reviewer_or_owner(user)
    current_reviewer.id == user.id || current_owner.id == user.id
  end

  def closed_automatically?
    return false if self.reconsideration_or_appeal_clock.blank?
    self.closed? && self.reconsideration_or_appeal_clock <= 55.days.ago
  end

  def close_appeal?
    return false if self.reconsideration_or_appeal_clock.blank?
    self.reconsideration_or_appeal_clock <= 55.days.ago
  end

  def remove_current_assignment
    Review.transaction do
      self.update_attributes(current_assignment_id: nil)
    end
  end

  private

  # invoke the workflow event unless it's nil or doesn't exist for the current state
  def send_event!(model, event)
    unless (event.nil? || !model.current_state.events.include?(event))
      model.send(:"#{event}!")
    end
  end

  def set_case_number
    self.case_number = "#{("A".."Z").to_a[rand(26)]}#{("A".."Z").to_a[rand(26)]}#{Time.now.to_i}"
  end
end
