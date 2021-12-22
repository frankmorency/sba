class App1214ChangeAppSectionHeader < ActiveRecord::Migration
  def change
        Questionnaire.get("mpp").sections.find_by(name: 'protege_active_agreement_docs').update_attribute(:title, 'Active Agreement Documents and Additional Documents')
  end
end
