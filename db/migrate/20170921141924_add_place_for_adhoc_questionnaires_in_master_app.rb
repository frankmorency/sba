class AddPlaceForAdhocQuestionnairesInMasterApp < ActiveRecord::Migration
  def change
        questionnaire = Questionnaire::EightAInitial.first
    section = questionnaire.root_section.children.find_by(name: 'eight_a_master')
    Section::AdhocQuestionnairesSection.create! name: 'adhoc_questions', title: 'Adhoc Questions', position: 7, submit_text: 'Save and continue', parent: section, questionnaire: questionnaire
  end
end
