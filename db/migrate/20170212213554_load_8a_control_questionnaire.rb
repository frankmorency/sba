class Load8aControlQuestionnaire < ActiveRecord::Migration
  def change
    
    qt_instance1 = QuestionType::Boolean.new name: 'yesno_with_comment_required_on_yes_with_attachment_optional_on_yes', title: 'Yes, No with Comments Required on Yes and Attachments Optional on Yes'
    qt_instance1.question_rules.new mandatory: true, value: 'yes', capability: :add_comment, condition: :equal_to
    qt_instance1.question_rules.new mandatory: false, value: 'yes', capability: :add_attachment, condition: :equal_to
    qt_instance1.save!

    qt_instance2 = QuestionType::YesNoNa.new name: 'yesnona_with_comment_required_on_no', title: 'Yes, No, or N/A with Comments Required on No'
    qt_instance2.question_rules.new mandatory: true, value: 'no', capability: :add_comment, condition: :equal_to
    qt_instance2.save!

    eight_a_control = Questionnaire::SubQuestionnaire.create! name: 'eight_a_control', title: '8(a) Control Application', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(A) Control Summary'

    eight_a_control.create_sections! do
      root 'eight_a_control', 0, title: '8(a) Control' do
        question_section 'eight_a_control_questions', 0, title: 'Control' do
          question_section 'eight_a_firm_control', 0, title: 'Firm Control', first: true do
            yesno_with_attachment_required_on_yes 'eight_a_control_existing_agreements', 0, title: 'Does the applicant firm have any existing agreements that might impact ownership or control? These may include:<br/> • joint venture<br/> • mentor protégé<br/> • indemnity<br/> • consulting<br/> • distributorship<br/> • licensing<br/> • teaming<br/> • trust<br/> • franchise<br/> • management'
            yesno_with_comment_required_on_yes_with_attachment_optional_on_yes 'eight_a_control_support', 1, title: 'Do any other firms or individuals provide financial support or bonding support to the applicant firm?'
            yesno_with_comment_required_on_yes_with_attachment_optional_on_yes 'eight_a_control_permits', 2, title: 'Do any other firms or individuals provide licensing, certifications, or permits to the applicant firm?'
            yesnona_with_comment_required_on_no 'eight_a_control_high_compensation', 3, title: 'Is the individual claiming disadvantaged status the highest compensated in the applicant firm?'
            null_with_attachment_required 'eight_a_control_signature_cards', 4, title: 'Please upload all business bank account signature cards.'
            yesno_with_attachment_required_on_yes 'eight_a_control_share_resources', 5, title: 'Is the applicant firm co-located with another firm at any of its locations or does it share any resources with any other firms?'
            yesno 'eight_a_control_lease', 6, title: 'Does the applicant firm lease or use office space or other facilities from any other firm?'
          end

          question_section 'eight_a_control_leased_facility', 1, title: 'Leased Facility', submit_text: 'Save and continue' do
            yesno_with_comment_required_on_yes 'eight_a_control_lease_relationship', 0, title: 'Do any Principals of the applicant firm have a financial or any other interest in or familial relationship with the owner of the leased facility?'
          end
        end

        review_section 'review', 1, title: 'Review', submit_text: 'Submit'
      end
    end

    eight_a_control.create_rules! do
      section_rule 'eight_a_firm_control', 'eight_a_control_leased_facility',
                   { klass: 'Answer', identifier: 'eight_a_control_lease', value: 'yes' }
      section_rule 'eight_a_firm_control', 'review',
                   { klass: 'Answer', identifier: 'eight_a_control_lease', value: 'no' }
      section_rule 'eight_a_control_leased_facility', 'review'
    end

    q1 = Question.find_by(name: 'eight_a_control_existing_agreements')
    q2 = Question.find_by(name: 'eight_a_control_support')
    q3 = Question.find_by(name: 'eight_a_control_permits')
    q4 = Question.find_by(name: 'eight_a_control_signature_cards')
    q5 = Question.find_by(name: 'eight_a_control_share_resources')

    doc_type1 = DocumentType.find_by(name: 'Joint venture agreements')
    doc_type2 = DocumentType.find_by(name: 'Mentor-Protégé Agreement')
    doc_type3 = DocumentType.create! name: 'Other Control Agreement'
    doc_type4 = DocumentType.create! name: 'Bank Account Signature Card'
    doc_type5 = DocumentType.create! name: 'Co-location Agreement and Terms'

    DocumentTypeQuestion.create! question_id: q1.id, document_type_id: doc_type1.id
    DocumentTypeQuestion.create! question_id: q1.id, document_type_id: doc_type2.id
    DocumentTypeQuestion.create! question_id: q1.id, document_type_id: doc_type3.id


    DocumentTypeQuestion.create! question_id: q2.id, document_type_id: doc_type3.id

    DocumentTypeQuestion.create! question_id: q3.id, document_type_id: doc_type3.id

    DocumentTypeQuestion.create! question_id: q4.id, document_type_id: doc_type4.id

    DocumentTypeQuestion.create! question_id: q5.id, document_type_id: doc_type5.id
  end
end