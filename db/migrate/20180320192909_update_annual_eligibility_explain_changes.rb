class UpdateAnnualEligibilityExplainChanges < ActiveRecord::Migration
  def change
    Question.where(name: 'explain_changes').first
            .update_attributes(possible_values: ["Firm ownership","Management (This includes changes in any officers, directors, or daily managers — and whether the person claiming disadvantage took a job outside your firm.)","Business structure","Primary NAICS code designation (SBA must approve any change to primary NAICS code.)","Articles of Incorporation","Partnership Agreement","Bylaws","Operating Agreement","Stock issues","Other things have changed.","None of the above have changed."])
  end
end
