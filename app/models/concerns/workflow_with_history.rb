# I AM APPARENTLY WORTHLESS - REPLACE ME WITH SOMETHING BETTER FOR ACTIVITY LOG

module WorkflowWithHistory
  extend ActiveSupport::Concern

  included do
    include       Workflow
    has_many      :workflow_changes, -> { order(created_at: :desc) }, as: :model, dependent: :destroy

    after_create  :capture_initial_workflow_state

    define_method :persist_workflow_state do |new_state|
      super(new_state)

      workflow_changes.create!(workflow_state: workflow_state)
    end
  end

  def status
    ['voluntary_withdrawn'].include?(workflow_state) ? 'Voluntarily Withdrawn' : workflow_state.titleize
  end

  def capture_initial_workflow_state
    workflow_changes.create!(workflow_state: workflow_state)
  end

  # applicable to both apps and certs
  def most_recent_certificate
    certificate_type.certificates.where(organization_id: organization_id, workflow_state: %w(active expired)).order(workflow_state: :asc, expiry_date: :asc).first
  end
end
