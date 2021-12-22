class AddIsTemplateToSectionRule < ActiveRecord::Migration
  def change
    add_column :section_rules, :is_multi_path_template, :boolean, default: false # does this rule contain a multi-path question that enables / disables other sections
    add_column :section_rules, :terminal_section_id, :integer # the next section to go to after the potential sections that are enabled by the multi-path rule
    add_column :section_rules, :generated_from_id, :integer # for dynamically created section rules (from multi path questions), this points to the original section_rule that created the section

    add_column :sections, :defer_applicability_for_id, :integer  # multi-path sections need to be skipped when going to the review section, this is how we know what they are

    Section.reset_column_information
    Section::ApplicationSection.reset_column_information
    Section::PersonalPrivacy.reset_column_information
    Section::QuestionSection.reset_column_information
    Section::RealEstate.reset_column_information
    Section::ReviewSection.reset_column_information
    Section::Root.reset_column_information
    Section::SignatureSection.reset_column_information
    Section::Spawner.reset_column_information
    Section::Template.reset_column_information
    SectionRule.reset_column_information
  end
end
