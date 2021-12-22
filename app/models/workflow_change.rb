class WorkflowChange < ActiveRecord::Base
  acts_as_paranoid

  belongs_to  :model, polymorphic: true
  belongs_to  :user
end
