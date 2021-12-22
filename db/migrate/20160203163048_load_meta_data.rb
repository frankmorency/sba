class LoadMetaData < ActiveRecord::Migration
  def change

    %w(admin vendor_admin vendor_viewer third_party_certifier sba_admin sba_analyst sba_analyst_viewer legal_analyst contracting_auditor).each do |name|
      Role.create!(name: name)
    end

    yesno = QuestionType::Boolean.create! name: 'yesno', title: "Yes or No"

    naics = QuestionType::NaicsCode.create! name: 'naics_code', title: "Naics Code"

    na_with_comments = QuestionType::YesNoNa.new name: 'yesnona_with_comment', title: 'Yes, No, or N/A with Comments'
    na_with_comments.question_rules.new mandatory: false, value: 'na', capability: :add_comment, condition: :equal_to
    na_with_comments.save!

    comment_required = QuestionType::YesNoNa.new name: 'yesnona_with_comment_required', title: 'Yes, No, or N/A with Comment Required'
    comment_required.question_rules.new mandatory: true, value: 'na', capability: :add_comment, condition: :equal_to
    comment_required.save!

    QuestionType::YesNoNa.create! name: 'yesnona', title: "Yes, No, or N/A"

    na_with_attachment = QuestionType::YesNoNa.new name: 'yesnona_with_attachment', title: 'Yes, No, or N/A with Attachment'
    na_with_attachment.question_rules.new mandatory: false, value: 'na', capability: :add_attachment, condition: :equal_to
    na_with_attachment.save!

    attachment_required = QuestionType::YesNoNa.new name: 'yesnona_with_attachment_required', title: 'Yes, No, or N/A with Attachment Required'
    attachment_required.question_rules.new mandatory: true, value: 'na', capability: :add_attachment, condition: :equal_to
    attachment_required.save!

    yesno_with_comment_required_on_no = QuestionType::Boolean.new name: 'yesno_with_comment_required_on_no', title: 'Yes or No with Comment Required'
    yesno_with_comment_required_on_no.question_rules.new mandatory: true, value: 'no', capability: :add_comment, condition: :equal_to
    yesno_with_comment_required_on_no.save!

    yesno_with_attachment = QuestionType::Boolean.new name: 'yesno_with_attachment', title: 'Yes or No with Attachment'
    yesno_with_attachment.question_rules.new mandatory: false, value: 'na', capability: :add_attachment, condition: :equal_to
    yesno_with_attachment.save!

    yesno_with_attachment_required_on_yes = QuestionType::Boolean.new name: 'yesno_with_attachment_required_on_yes', title: 'Yes or No with Attachment Required'
    yesno_with_attachment_required_on_yes.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    yesno_with_attachment_required_on_yes.save!

    yesnonawithcommentrequiredonNAanduploadrequiredonyes = QuestionType::YesNoNa.new name: 'yesnona_with_comment_on_na_required_with_attachment_on_yes_required', title: 'Yes, No, or N/A with Comments on N/A Required and Attachments on Yes Required'
    yesnonawithcommentrequiredonNAanduploadrequiredonyes.question_rules.new mandatory: true, value: 'na', capability: :add_comment, condition: :equal_to
    yesnonawithcommentrequiredonNAanduploadrequiredonyes.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    yesnonawithcommentrequiredonNAanduploadrequiredonyes.save!

    yesnonawithcommentrequiredonNAanduploadrequiredonNA = QuestionType::YesNoNa.new name: 'yesnona_with_comment_on_na_required_with_attachment_on_na_required', title: 'Yes, No, or N/A with Comments on N/A Required and Attachments on N/A Required'
    yesnonawithcommentrequiredonNAanduploadrequiredonNA.question_rules.new mandatory: true, value: 'na', capability: :add_comment, condition: :equal_to
    yesnonawithcommentrequiredonNAanduploadrequiredonNA.question_rules.new mandatory: true, value: 'na', capability: :add_attachment, condition: :equal_to
    yesnonawithcommentrequiredonNAanduploadrequiredonNA.save!

    yesnonawithcommentoptionalonNAanduploadoptionlonNA = QuestionType::YesNoNa.new name: 'yesnona_with_comment_on_na_optional_with_attachment_on_na_optional', title: 'Yes, No, or N/A with Comments on N/A Optional and Attachments on N/A Optional'
    yesnonawithcommentoptionalonNAanduploadoptionlonNA.question_rules.new mandatory: false, value: 'na', capability: :add_comment, condition: :equal_to
    yesnonawithcommentoptionalonNAanduploadoptionlonNA.question_rules.new mandatory: false, value: 'na', capability: :add_attachment, condition: :equal_to
    yesnonawithcommentoptionalonNAanduploadoptionlonNA.save!

    yesnonawithcommentrequiredonnoanduploadrequiredonno = QuestionType::YesNoNa.new name: 'yesnona_with_comment_on_no_required_with_attachment_on_no_required', title: 'Yes, No, or N/A with Comments on No Required and Attachments on No Required'
    yesnonawithcommentrequiredonnoanduploadrequiredonno.question_rules.new mandatory: true, value: 'no', capability: :add_comment, condition: :equal_to
    yesnonawithcommentrequiredonnoanduploadrequiredonno.question_rules.new mandatory: true, value: 'no', capability: :add_attachment, condition: :equal_to
    yesnonawithcommentrequiredonnoanduploadrequiredonno.save!

    yesno_with_table_required_on_yes = QuestionType::Table.new name: 'yesno_with_table_required_on_yes', title: 'Yes or No with Table Required'
    yesno_with_table_required_on_yes.save!

    qt = QuestionType::YesNoNa.new name: 'yesnona_with_comment_on_no_required_with_attachment_on_yes_required', title: 'Yes, No, or N/A with Comments on No Required and Attachments on Yes Required'
    qt.question_rules.new mandatory: true, value: 'no', capability: :add_comment, condition: :equal_to
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    qt.save!

    qt = QuestionType::Boolean.new name: 'yesno_with_comment_on_no_required_with_attachment_on_yes_required', title: 'Yes, No with Comments on No Required and Attachments on Yes Required'
    qt.question_rules.new mandatory: true, value: 'no', capability: :add_comment, condition: :equal_to
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    qt.save!

    ApplicationStatusType.create!(name: 'Draft', description: 'Draft State')
    ApplicationStatusType.create!(name: 'Submitted', description: 'Submitted State')

    DocumentType.create! name: "Third Party Certification"
    DocumentType.create! name: "Annual TPC Letter"
    DocumentType.create! name: "Stock ledger"
    DocumentType.create! name: "Stock certificates"
    DocumentType.create! name: "Articles of incorporation"
    DocumentType.create! name: "By-laws"
    DocumentType.create! name: "Articles of incorporation amendments"
    DocumentType.create! name: "Joint venture agreements"
    DocumentType.create! name: "Partnership agreement"
    DocumentType.create! name: "Partnership agreement amendments"
    DocumentType.create! name: "Doing Business As (DBA)"
    DocumentType.create! name: "Articles of organization"
    DocumentType.create! name: "Amendments to the Articles of Organization"
    DocumentType.create! name: "Operating agreement"
    DocumentType.create! name: "Birth certificates"
    DocumentType.create! name: "Naturalization papers"
    DocumentType.create! name: "Unexpired passports"
    DocumentType.create! name: "8(a) Certification"
    DocumentType.create! name: "Annual 8(a) Letter"
    DocumentType.create! name: "Voting agreement"
    DocumentType.create! name: "IRS Form 4506-T"
    DocumentType.create! name: "By-laws amendments"
    DocumentType.create! name: "DOT DBE Certification"
    DocumentType.create! name: "Operating agreement amendments"
    DocumentType.create! name: "Miscellaneous"
    DocumentType.create! name: "Personal income tax returns"
    DocumentType.create! name: "Separation agreement from spouse"

    #Legacy types - not used in rails application
    DocumentType.create! name: "Proposal, Quote or Bid"
    DocumentType.create! name: "SBA Form 413, Personal Financial Statement"
    DocumentType.create! name: "Women-Owned Small Business Program Certification-EDWOSB Certification Form 2414 for EDWOSB"
    DocumentType.create! name: "Women-Owned Small Business Program Certification-WOSB Certification Form 2413 for WOSB"
    DocumentType.create! name: "Legacy Unknown Types"
    DocumentType.create! name: "Unknown"

    CertificateStatusType.create!(name: 'Active', description: 'Active State')
    CertificateStatusType.create!(name: 'Inactive', description: 'Inactive State')
    CertificateStatusType.create!(name: 'Archived', description: 'Archived State')
  end
end
