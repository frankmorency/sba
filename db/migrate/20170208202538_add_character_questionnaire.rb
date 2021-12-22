class AddCharacterQuestionnaire < ActiveRecord::Migration
  def change
    
    DocumentType.create! name: 'Character'

    character = Questionnaire::SubQuestionnaire.create! name: 'eight_a_character', title: 'Character', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(A) Character Summary'

    character.create_sections! do
      root 'character_root', 1, title: '8(a) Character' do
        question_section 'character', 1, title: 'Character', first: true do
          yesno_with_attachment_optional_on_yes 'character_16a', 1, title: 'Has the applicant firm (under any name) ever been debarred or suspended by any Federal entity?'
          yesno_with_attachment_required_on_yes 'character_16b', 1, title: 'Does the applicant firm have any outstanding delinquent Federal, state or local financial obligations or liens filed against it?'
          yesno_with_attachment_required_on_yes 'character_16c', 1, title: 'Is the applicant firm a defendant in any pending lawsuit?'
          yesno_with_attachment_required_on_yes 'character_16d', 1, title: 'Has the applicant firm filed for bankruptcy or insolvency within the past 7 years?'
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
      end
    end

    character.create_rules! do
      section_rule 'character', 'review'
    end

    q1 = Question.find_by(name: 'character_16a')
    q2 = Question.find_by(name: 'character_16b')
    q3 = Question.find_by(name: 'character_16c')
    q4 = Question.find_by(name: 'character_16d')

    DocumentTypeQuestion.create! question_id: q1.id, document_type_id: DocumentType.find_by_name("Unknown").id
    DocumentTypeQuestion.create! question_id: q2.id, document_type_id: DocumentType.find_by_name("Unknown").id
    DocumentTypeQuestion.create! question_id: q3.id, document_type_id: DocumentType.find_by_name("Unknown").id
    DocumentTypeQuestion.create! question_id: q4.id, document_type_id: DocumentType.find_by_name("Unknown").id
  end
end