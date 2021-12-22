module SbaApplicationMaster
  extend ActiveSupport::Concern

  def master
    questionnaire
  end

  def master_question_presentations
    master.question_presentations
  end

  def master_root
    master.root_section
  end

  def master_templates
    master.templates
  end

  def master_rules
    master.every_section_rule
  end

  def master_sections
    master.sections
  end

  def master_first
    master.first_section
  end
end