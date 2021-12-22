class App220ChangeSectionRule < ActiveRecord::Migration
  def change
    
    mpp_questionnaire = Questionnaire.find_by_name('mpp').id
    from_section = Section.find_by(questionnaire_id: mpp_questionnaire, name: 'eight_a_participants', sba_application_id: nil).id
    to_section = Section.find_by(questionnaire_id: mpp_questionnaire, name: 'review', sba_application_id: nil).id

    new_to_section = Section.find_by(questionnaire_id: mpp_questionnaire, name: 'mentor_business_info', sba_application_id: nil)

    section_rule = SectionRule.find_by(questionnaire_id: mpp_questionnaire,
                                       from_section: from_section,
                                       to_section: to_section)

    section_rule.update_attributes to_section: new_to_section

  end
end
