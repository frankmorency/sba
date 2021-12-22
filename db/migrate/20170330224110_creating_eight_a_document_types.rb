class CreatingEightADocumentTypes < ActiveRecord::Migration
  def change
    [ "CRBA", "External Job Details", "External Business", "Prior 8(a) involvement", "Letter of No Objection", 
    "Bankruptcy Court Final Order", "Bankruptcy Court Discharge", "Bankruptcy explaination", "Other Bankruptcy", 
    "SBA loan details", "Pending lawsuit details", "Debt obligations", "Criminal record narrative", "Criminal court record", 
    "Form FD-258 Fingerprint Card", "1099", "Tax Schedule", "Tax Form", "1040", "4506-T", "Other Tax Document", 
    "Native American Entity Documentation", "Discriminatory Narrative"].each do |doc_type|
      DocumentType.create! name: doc_type
    end
  end
end
