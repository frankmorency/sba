class UpdateBusinessOwnershipQuestionnaireSectionRule < ActiveRecord::Migration
  def change
    
    bo_questionnaire_id = Questionnaire.find_by_name('eight_a_business_ownership').id

    from_section_id = Section.find_by(questionnaire_id: bo_questionnaire_id, name: 'eight_a_business_ownership_details', sba_application_id: nil).id

    to_section_id = Section.find_by(questionnaire_id: bo_questionnaire_id, name: 'eight_a_business_ownership_sole_proprietor', sba_application_id: nil).id

    section_rule = SectionRule.find_by(questionnaire_id: bo_questionnaire_id, from_section: from_section_id, to_section: to_section_id)

    section_rule.update_attributes(expression: "{\"klass\":\"Organization\",\"field\":\"business_type\",\"operation\":\"equal\",\"value\":\"sole_prop\"}")
  end
end
