class Determination < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  DECISIONS = ["SBA Declined", "SBA Approved"]

  DECISION_LABELS = {
    "decline_ineligible" => "SBA Declined",
    "sba_approved" => "SBA Approved",
  }

  # NOTE: ONLY ADD TO THE END OF THIS LIST OR EXISTING STATUSES WILL CHANGE !!!
  enum decision: [:decline_ineligible, :sba_approved]

  has_one :review
  belongs_to :decider, class_name: "User"

  validates :decision, inclusion: { in: Determination.decisions }

  delegate :certificate, to: :review

  def display_decision
    DECISION_LABELS[decision]
  end
end
