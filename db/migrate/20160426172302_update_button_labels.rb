class UpdateButtonLabels < ActiveRecord::Migration
  def change
    Section.where(submit_text: 'Continue').update_all submit_text: 'Save and continue'
    Section.where(name: 'personal_privacy').update_all submit_text: 'Continue'
    Section.where(name: 'review').update_all submit_text: 'Submit'
    Section.where(name: 'signature').update_all submit_text: 'Accept'
  end
end
