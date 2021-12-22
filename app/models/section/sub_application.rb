require_relative '../section'

class Section::SubApplication < Section
  belongs_to  :sub_questionnaire, class_name: 'Questionnaire::SubQuestionnaire'
  belongs_to  :sub_application, class_name: 'SbaApplication::SubApplication'
  belongs_to  :related_to_section, class_name: 'Section::SubApplication'

  def self.prerequisite
    includes(:sub_application).where.not(sba_applications: {prerequisite_order: nil})
  end

  def vendor_admin_user
    sba_application.organization.vendor_admin_user
  end

  def adhoc_questionnaires
    sba_application.adhoc_section_root.children.where(related_to_section_id: id)
  end

  def has_adhoc_questionnaires?
    adhoc_questionnaires.count > 0
  end

  def adhoc_questionnaires_to_complete
    adhoc_questionnaires.where.not(status: Section::COMPLETE)
  end

  def has_adhoc_questionnaires_to_complete?
    adhoc_questionnaires_to_complete.size > 0
  end
end