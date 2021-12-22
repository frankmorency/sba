class DataFixForDe117 < ActiveRecord::Migration
  def change
    ignore_status = ApplicationStatusType.find_by(name: 'Submitted')
    SbaApplication.where.not(application_status_type_id: ignore_status.try(:id)).each do |app|
      review_id = app.sections.find_by(name: 'review').id
      personal_privacy = app.sections.where('name like ?', 'personal_privacy_%').order('created_at desc').first

      next unless review_id && personal_privacy

      app.section_rules.where(to_section_id: review_id).each do |rule|
        if %w(cash_on_hand other_sources_of_income notes_receivable retirement_accounts life_insurance stocks_bonds real_estate_primary real_estate_other personal_property notes_payable assessed_taxes agi personal_summary).any? {|sec| rule.from_section.name =~ /^#{sec}_/ }
          Rails.logger.warn("DE117 - Updating #{app} with section (#{rule.debug}) to set from_section to #{personal_privacy} (#{personal_privacy.id})")
          rule.update_attribute(:from_section_id, personal_privacy.id)
          app.update_skip_info!
          Rails.logger.warn("DE117 - Update complete.")
        end
      end
    end
  end
end
