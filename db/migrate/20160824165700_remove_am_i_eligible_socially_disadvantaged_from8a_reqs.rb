class RemoveAmIEligibleSociallyDisadvantagedFrom8aReqs < ActiveRecord::Migration
  def change
    
    hi = Question.get("socially_disadvantaged").question_presentations.first.helpful_info
    hi['requirements'] = []
    Question.get("socially_disadvantaged").question_presentations.first.update_attribute(:helpful_info, hi)
  end
end
