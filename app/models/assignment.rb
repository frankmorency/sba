class Assignment < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index("cases_v2#organization") do
      review.certificate.organization if review
    end

    # Old index, remove when UI is retired
    #update_index('cases#certificate') { certificate }
  end

  acts_as_paranoid
  has_paper_trail

  belongs_to :review
  belongs_to :supervisor, class_name: "User"
  belongs_to :owner, class_name: "User"
  belongs_to :reviewer, class_name: "User"

  before_validation :set_reviewer, on: :create

  validates :reviewer, :owner, :supervisor, presence: true
  validate :assigned_to_analysts

  private

  def assigned_to_analysts
    errors.add(:supervisor, "must be an sba analyst") unless (supervisor.can? :change_assignment, supervisor) if supervisor
    errors.add(:owner, "must be an sba analyst") unless (owner.can? :change_assignment, owner) if owner
    errors.add(:reviewer, "must be an sba analyst") unless (reviewer.can? :change_assignment, reviewer) if reviewer
  end

  def set_reviewer
    self.reviewer = owner unless reviewer
  end
end
