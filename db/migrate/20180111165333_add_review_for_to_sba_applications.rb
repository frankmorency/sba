class AddReviewForToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :review_for, :date, null: true # this is the date the annual review is set for
    add_column :sba_applications, :review_number, :integer, null: true # this is the number of the review 1 thru 8

    Section::SubQuestionnaire.where(name: 'bdmis_archive').update_all sub_questionnaire_id: Questionnaire.get('bdmis_archive').id
  end
end
