class CreateBusinessOwnershipQuestionnaire < ActiveRecord::Migration
  def change

    
    new_question = QuestionType::SixQuestionsPercentage.new name: 'six_questions_percentage', title: 'Six Questions Percentage'
    new_question.save!

    new_question = QuestionType::Boolean.new name: 'yesno_with_comment_optional_on_yes_with_attachment_optional_on_yes', title: 'Yes No with Comment and Attachment Optional on Yes'
    new_question.question_rules.new mandatory: false, value: 'yes', capability: :add_comment, condition: :equal_to
    new_question.question_rules.new mandatory: false, value: 'yes', capability: :add_attachment, condition: :equal_to
    new_question.save!

    business_ownership = Questionnaire::SubQuestionnaire.create! name: 'eight_a_business_ownership', title: '8(a) Business Ownership', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Business Ownership'

    business_ownership.create_sections! do
      root 'eight_a_business_ownership', 1, title: '8(a) Business Ownership' do

        question_section 'ownership', 0, title: 'Ownership' do
          question_section 'eight_a_business_ownership_entity', 1, title: 'Entity Ownership', submit_text: 'Save and continue', first: true do
            six_questions_percentage 'ownership_percentage', 0, title: 'Who owns the applicant firm? Please detail the ownership percentages of the applicant firm:'
            yesno_with_comment_required_on_yes_with_attachment_required_on_yes '51_percent_owned_other_entity', 1, title: 'Is the applicant firm at least 51% or more unconditionally owned by another entity?'
          end
          question_section 'eight_a_business_ownership_details', 2, title: 'Ownership Details', submit_text: 'Save and continue' do
            picklist 'how_acquired', 0, title: 'How did the Principal Owner(s) acquire the applicant firm?', possible_values: ['Started the applicant firm', 'Bought the applicant firm', 'Acquired the applicant firm as a gift, an inheritance, or a transfer', 'Acquired the applicant firm through a merger or consolidation']
            yesno_with_comment_required_on_yes_with_attachment_required_on_yes 'ownership_structure_name_changed', 1, title: "Has the applicant firm’s ownership, legal structure, or name changed in the past two years?"
            yesno_with_attachment_required_on_yes 'arrangement_impact_on_dvd_ownership', 2, title: "Does the applicant firm have any buy-sell agreements, shareholder agreements, or other similar arrangements which may impact the unconditional ownership of the disadvantaged individuals?"
            yesnona_with_attachment_required_on_yes 'ownership_interest_in_other_firm', 3, title: 'Does the applicant firm currently have ownership interest in any other firm?'
            yesnona_with_attachment_required_on_yes 'more_than_10_percent', 4, title: 'Does another firm or other organization have more than 10% ownership interest in the applicant firm?'
          end
          question_section 'eight_a_business_ownership_corporation', 3, title: 'Corporations', submit_text: 'Save and continue' do
            null_with_attachment_required 'upload_relevant_corporation_documents_q0', 0, title: "Please upload all relevant documents from the following list:<ul><li>Articles of Incorporation (original and current version)</li><li>Bylaws (current version)</li><li>The most recent Stockholder or Board Member Meeting Minutes showing the election of officers and directors</li></ul>"
            null_with_attachment_required 'upload_relevant_corporation_documents_q1', 1, title: "Please upload all relevant documents from the following list:<ul><li>Stock certificates (front and back)</li><li>Stock ledgers</li><li>Registers</li><li>Transmutation agreements (for community property states)</li><li>Voting agreements</li></ul>"
            null_with_attachment_required 'upload_current_certificate_of_good_standing_corporation', 2, title: 'Please upload the applicant firm’s current Certificate of Good Standing. '
          end
          question_section 'eight_a_business_ownership_llc', 4, title: 'LLCs', submit_text: 'Save and continue' do
            null_with_attachment_required 'upload_relevant_llc_documents', 0, title: "Please upload all relevant documents from the following list:<ul><li>Articles of Organization (original and current version)</li><li>Operating Agreement (current version)</li><li>Resolutions (see details below)</li><li>Membership shares and ledgers (see details below)</li></ul>"
            null_with_attachment_required 'upload_current_certificate_of_good_standing_llc', 1, title: 'Please upload the applicant firm’s current Certificate of Good Standing. '
          end
          question_section 'eight_a_business_ownership_partnership', 5, title: 'Partnerships', submit_text: 'Save and continue' do
            null_with_attachment_required 'upload_current_partnership_agreement', 0, title: 'Please upload the applicant firm’s current Partnership Agreement.'
          end
          question_section 'eight_a_business_ownership_sole_proprietor', 6, title: 'Sole Proprietors', submit_text: 'Save and continue' do
            yesno_with_comment_optional_on_yes_with_attachment_optional_on_yes 'confirm_and_upload_DBA', 0, title: 'Does the applicant firm have a Doing Business As (DBA) Name?'
          end
        end

        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
      end
    end

    business_ownership.create_rules! do
      section_rule 'eight_a_business_ownership_entity', 'eight_a_business_ownership_details'

      section_rule 'eight_a_business_ownership_details', 'eight_a_business_ownership_corporation', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: ['corp', 's-corp']
      }
      section_rule 'eight_a_business_ownership_details', 'eight_a_business_ownership_llc', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: 'llc'
      }
      section_rule 'eight_a_business_ownership_details', 'eight_a_business_ownership_partnership', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: 'partnership'
      }
      section_rule 'eight_a_business_ownership_details', 'eight_a_business_ownership_sole_proprietor', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: 'sole-prop'
      }

      section_rule 'eight_a_business_ownership_corporation', 'review'
      section_rule 'eight_a_business_ownership_llc', 'review'
      section_rule 'eight_a_business_ownership_partnership', 'review'
      section_rule 'eight_a_business_ownership_sole_proprietor', 'review'
    end


    [ '1010 - AIT', '1010 - ANC', '1010 - CDC', '1010 - NHO', 'Prior Ownership Documents', 'Buy-Sell Agreement', 'Shareholder Agreement',
    'Other Ownership Agreement', 'Articles of Incorporation', 'Articles of Incorporation amendments', 'By-laws', 'Meeting Minutes',
    'Registers', 'Transmutation agreements (for community property states)', 'Voting agreement', 'Certificate of Good Standing',
    'Resolutions', 'Membership shares and ledgers (see details below)', 'DBA Name Certificate', 'Fictitious Business Name Filing'].each do |doc_type|
      DocumentType.create! name: doc_type
    end

    q = Question.find_by(name: '51_percent_owned_other_entity')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("1010 - AIT").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("1010 - ANC").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("1010 - CDC").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("1010 - NHO").id

    q = Question.find_by(name: 'ownership_structure_name_changed')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Prior Ownership Documents").id

    q = Question.find_by(name: 'arrangement_impact_on_dvd_ownership')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Buy-Sell Agreement").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Shareholder Agreement").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Other Ownership Agreement").id

    q = Question.find_by(name: 'ownership_interest_in_other_firm')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Other Ownership Agreement").id

    q = Question.find_by(name: 'more_than_10_percent')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Other Ownership Agreement").id

    q = Question.find_by(name: 'upload_relevant_corporation_documents_q0')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation amendments").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("By-laws").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Meeting Minutes").id

    q = Question.find_by(name: 'upload_relevant_corporation_documents_q1')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Copies of stock certificates (front and back)").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Stock ledger").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Registers").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Transmutation agreements (for community property states)").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Voting agreement").id

    q = Question.find_by(name: 'upload_current_certificate_of_good_standing_corporation')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Certificate of Good Standing").id

    q = Question.find_by(name: 'upload_relevant_llc_documents')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation amendments").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Operating agreement").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Resolutions").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Membership shares and ledgers (see details below)").id

    q = Question.find_by(name: 'upload_current_certificate_of_good_standing_llc')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Certificate of Good Standing").id

    q = Question.find_by(name: 'upload_current_partnership_agreement')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Partnership agreement").id

    q = Question.find_by(name: 'confirm_and_upload_DBA')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("DBA Name Certificate").id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Fictitious Business Name Filing").id

    Section.where(questionnaire_id: Questionnaire.get('eight_a_business_ownership').id, name: 'review').update_all is_last: true

  end
end
