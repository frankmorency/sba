class UpdateMppQuestionnaireMaximumAllowedValue < ActiveRecord::Migration
  def change
        Questionnaire.reset_column_information
    mpp = Questionnaire.find_by_name('mpp')
    mpp.maximum_allowed = 2 if mpp
    mpp.save!
  end
end
