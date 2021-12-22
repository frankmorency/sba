class MoveMaximumAllowedToQuestionnaire < ActiveRecord::Migration
  def change
    unless Questionnaire.column_names.include?('maximum_allowed')
      add_column  :questionnaires, :maximum_allowed, :integer, default: 1 # same as in certificate type - moved here because there can be different types of questionnaires: initial, annual review, etc.
    end

    add_column  :questionnaires, :review_page_display_title, :string # the display title on the review page
    add_column  :questionnaires, :link_label, :string # the label used when linking to this questionnaire
    add_column  :questionnaires, :human_name, :string # the human name or short name used to refer to the   questionnaire (EDWOSB, etc.)

    CertificateType.all.each do |cert_type|
      if q = cert_type.questionnaires.order(updated_at: :desc).first
        q.update_attribute(:maximum_allowed, cert_type.maximum_allowed)
      end
    end

    remove_column :certificate_types, :maximum_allowed


    Questionnaire.reset_column_information

    if q = Questionnaire.find_by(name: 'edwosb')
      q.update_attributes review_page_display_title: "Economically Disadvantaged Women-Owned Small Business Program Self-Certification Summary", human_name: 'EDWOSB', link_label: "EDWOSB Self-Certification"
    end

    if q = Questionnaire.find_by(name: 'wosb')
      q.update_attributes review_page_display_title: "Women-Owned Small Business Program Self-Certification Summary", human_name: 'WOSB', link_label: "WOSB Self-Certification"
    end

    if q = Questionnaire.find_by(name: 'mpp')
      q.update_attributes review_page_display_title: "All Small Mentor Protégé Program Program Self-Certification Summary", human_name: 'MPP', link_label: 'MPP Application'
    end

    if q = Questionnaire.find_by(name: 'eight_a')
      q.update_attributes review_page_display_title: "8(a) Document Upload", human_name: "8(a) Document Upload", link_label: "8(a) Document Upload"
    end
  end
end
