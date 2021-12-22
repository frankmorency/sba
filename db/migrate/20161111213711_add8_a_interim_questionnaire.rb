class Add8AInterimQuestionnaire < ActiveRecord::Migration
  def change
    
    DocumentType.create! name: '8a Document (Interim)'

    program = Program.create!(name: 'eight_a', title: '8(a)')
    Group.create!(name: 'eight_a', title: '8(a)', program: program)

    CertificateType.create!(name: 'eight_a', title: '8(a)')

    eight_a = Questionnaire.create! name: 'eight_a', title: '8(a) Interim Questionnaire', anonymous: false, program: program

    CertificateType.get('eight_a').update_attribute(:questionnaire_id, eight_a.id)

    eight_a.create_sections! do
      root 'eight_a_interim', 1, title: '8(a) Application' do
        question_section 'eight_a_documents', 0, title: '8(a) Document Upload', first: true do
          null_with_attachment_required 'eight_a_documents', 1, title: 'Please upload the completed, signed forms you downloaded from BDMIS as well as the supporting documents as described in the application checklist.', document_types: '8a Document (Interim)'
        end
        review_section 'review', 3, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 4, title: 'Signature', submit_text: 'Accept'
      end
    end

    eight_a.create_rules! do
      section_rule 'eight_a_documents', 'review'
      section_rule 'review', 'signature'
    end
  end
end
