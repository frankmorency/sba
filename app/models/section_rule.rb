class SectionRule < ActiveRecord::Base
  include Versionable

  acts_as_paranoid
  has_paper_trail

  belongs_to :questionnaire
  belongs_to :from_section, class_name: "Section", foreign_key: "from_section_id"
  belongs_to :to_section, class_name: "Section", foreign_key: "to_section_id"
  belongs_to :template_root, class_name: "Section::Template", foreign_key: "template_root_id"
  belongs_to :generated_from, class_name: "SectionRule", foreign_key: "generated_from_id"
  belongs_to :terminal_section, class_name: "Section", foreign_key: "terminal_section_id"

  has_many :generated_rules, class_name: "SectionRule", foreign_key: "generated_from_id"

  validate :has_a_from_or_to_section

  def to_template_section(app, value)
    app.sections.find_by(name: to_section.customize_name(value)) ||
      app.sections.find_by(name: to_section.old_customize_name(value))
  end

  def from_template_section(app, value)
    app.sections.find_by(name: from_section.customize_name(value)) ||
      app.sections.find_by(name: from_section.old_customize_name(value))
  end

  def debug
    "#{questionnaire.try(:name)}#{sba_application_id ? " (#{sba_application.organization.get_corresponding_sam_organization.try(:legal_business_name)})" : nil}: #{from_section.try(:name)} => #{to_section.try(:name)}#{expression ? " \n\twhen #{expression}" : nil}#{template_root ? " [#{template_root.name}]" : nil}"
  end

  def to_s
    "#{from_section.name} => #{to_section.try(:name)}"
  end

  private

  def has_a_from_or_to_section
    unless from_section || to_section
      errors[:base] << "A section must have either a from or a to_section"
    end
  end
end
