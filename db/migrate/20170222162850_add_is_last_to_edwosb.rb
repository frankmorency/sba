class AddIsLastToEdwosb < ActiveRecord::Migration
  def change
    SectionRule.where(to_section_id: Section.where(name: 'review').pluck(:id)).each do |rule|
      if rule.from_section.name == 'form413' || rule.from_section.name =~ /^personal_privacy_/
        Rails.logger.warn("APP320 - Updating rule (#{rule.debug}) to set is_last to true")
        rule.update_attribute(:is_last, true)
        Rails.logger.warn("APP320 - Updating rule complete.")
      end
    end
  end
end
