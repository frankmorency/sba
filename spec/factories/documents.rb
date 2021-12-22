FactoryBot.define do
  factory :vendor_admin_doc, class: Document do
    stored_file_name Time.now.to_i.to_s
    original_file_name 'qa_automation.pdf'
    document_type DocumentType.first
    is_active true
  end
end
