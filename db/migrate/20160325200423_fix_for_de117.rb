class FixForDe117 < ActiveRecord::Migration
  def change
    SectionRule.where(to_section_id: Section.where(name: 'review').pluck(:id)).each do |rule|
      if rule.from_section.name == 'form413' || rule.from_section.name =~ /^personal_privacy_/
        Rails.logger.warn("DE117 - Updating rule (#{rule.debug}) to set is_last to true")
        rule.update_attribute(:is_last, true)
        Rails.logger.warn("DE117 - Updating rule complete.")
      end
    end

    Questionnaire.all.each do |questionnaire|
      next if questionnaire.name == 'am_i_eligible'

      from_id = questionnaire.sections.find_by(name: 'third_party_cert_part_2', sba_application_id: nil).try(:id)
      to_id = questionnaire.sections.find_by(name: 'signature', sba_application_id: nil).try(:id)
      review = questionnaire.sections.find_by(name: 'review', sba_application_id: nil)

      next unless from_id && to_id && review

      rule = questionnaire.section_rules.find_by(
          sba_application_id: nil,
          from_section_id: from_id,
          to_section_id: to_id
      )

      if rule
        Rails.logger.warn("DE117 - Updating rule (#{rule.debug}) to set to_section to #{review} (#{review.id})")
        rule.update_attribute(:to_section_id, review.id)
        Rails.logger.warn("DE117 - Updating rule complete)")
      end

    end

    ignore_status = ApplicationStatusType.find_by(name: 'Submitted')

    SbaApplication.where.not(application_status_type_id: ignore_status.try(:id)).each do |app|
      from_id = app.sections.find_by(name: 'third_party_cert_part_2').try(:id)
      to_id = app.sections.find_by(name: 'signature').try(:id)
      review = app.sections.find_by(name: 'review')

      next unless from_id && to_id && review

      rule = app.section_rules.find_by(
          from_section_id: from_id,
          to_section_id: to_id
      )
      if rule
        Rails.logger.warn("DE117 - Updating rule (#{rule.debug}) to set to_section to #{review} (#{review.id})")
        rule.update_attribute(:to_section_id, review.id)
        app.update_skip_info!
        Rails.logger.warn("DE117 - Updating rule complete)")
      end
    end
  end
end
