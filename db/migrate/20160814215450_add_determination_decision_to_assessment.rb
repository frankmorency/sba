class AddDeterminationDecisionToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :determination_decision, :string # stores the current determination decision
  end
end
