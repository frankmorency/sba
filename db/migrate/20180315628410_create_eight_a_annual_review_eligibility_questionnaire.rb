class CreateEightAAnnualReviewEligibilityQuestionnaire < ActiveRecord::Migration
  def change
    Questionnaire.transaction do
      eight_a_annual_review_eligibility = Questionnaire::SubQuestionnaire.create! name: 'eight_a_annual_review_eligibility', title: '8(a) Annual Review Basic Eligibility', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Annual Review Eligibility Summary'
      eight_a_annual_review_eligibility.create_sections! do
        root 'eight_a_annual_review_eligibility', 1, title: 'Annual Review Basic Eligibility' do

          question_section 'eight_a_annual_review_eligibility_header', 0, title: 'Eligibility' do
            question_section 'eight_a_annual_review_eligibility_update_info', 1, title: 'Update Your Info', submit_text: 'Save and continue', first: true  do
              yesno 'information_current', 0, title: 'Is your firm&apos;s information current in SAM.gov?', disqualifier: {value: 'no', message: "Your firm/'s information in <a href='https://www.sam.gov/portal/SAM/##11' target='_blank'>SAM.gov</a> must be current at the time of your annual review."}
            end
            question_section 'eight_a_annual_review_eligibility_explain_changes', 2, title: 'Explain Any Changes', submit_text: 'Save and continue' do
              checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection 'explain_changes', 0, title: 'Changes to your firm\'s circumstances could disqualify your firm from participating in the 8(a) program. <h3>Have there been changes to the following in the past program year or since your firm was certified as an 8(a) Participant?<br><br>Please select any changes not previously reported to SBA:</h3>', title_wrapper_tag: 'p',
                                                                                                    possible_values: ['Firm ownership', 'Management', 'Business structure', 'Primary NAICS code designation (SBA must approve any change to primary NAICS code.)', 'Articles of Incorporation', 'Partnership Agreement', 'Bylaws', 'Operating Agreement', 'Stock issues', 'Other things have changed.', 'None of the above have changed.']
              checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection 'integrity_character_changes', 1, title: 'Changes to your firm\'s circumstances could disqualify your firm from participating in the 8(a) program. (This includes changes in any officers, directors, or daily managers — and whether the person claiming disadvantage took a job outside your firm.) <h3>In the past program year or since your firm was certified as an 8(a) Participant, has there been conduct by your firm, or any of its principals, indicating a lack of business integrity or good character, which has resulted in any of the following?<br><br>Please check anything not previously reported to SBA:</h3>', title_wrapper_tag: 'p',
                                                                                                    possible_values: ['An arrest', 'Criminal indictment', 'A guilty plea or criminal conviction', 'A judgment or settlement in a civil lawsuit', 'Other consequences from lack of business integrity or good character', 'None of the above have occurred.']
              checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection 'adverse_actions', 2, title: 'In the past program year or since your firm was certified as an 8(a) Participant, are/have there been pending adverse actions that may affect your firm\'s business operations?<br><br>Please check all such actions not previously reported to SBA:',
                                                                                                    possible_values: ['Lawsuits', 'Delinquent taxes', 'Bankruptcy filings', 'Creditor problems', 'Contract disputes', 'Other adverse actions', 'None of the above have occurred.']
            end
            question_section 'eight_a_annual_review_eligibility_entity_ownership', 3, title: 'Entity Ownership', submit_text: 'Save and continue' do
              yesno_with_attachment_required_on_yes 'entity_owned', 0, title: 'Is your firm entity owned?'
            end
            question_section 'eight_a_annual_review_eligibility_tax_returns', 4, title: 'Tax Returns', submit_text: 'Save and continue' do
              null_with_attachment_required 'annual_review_tax_returns', 0, title: 'Please upload your firm&apos;s most recent income tax return filed with the IRS.'
            end
            question_section 'eight_a_annual_review_eligibility_financials', 5, title: 'Financials', submit_text: 'Save and continue' do
              null_with_attachment_required 'annual_review_financials', 0, title: 'Upload your firm\'s latest fiscal year-end balance sheet and income statements (profit and loss statements).'
            end

            composite_question_section 'eight_a_annual_review_eligibility_revenue', 6, title: 'Revenue', submit_text: 'Save and continue' do
              composite_question 'eight_a_annual_review_eligibility_revenue_response', 0, title: 'Enter all revenue earned in your last <span style="font-weight: 900;">PROGRAM YEAR</span> per your firm’s financial statements, including revenue earned through joint ventures.', title_wrapper_tag: 'p', sub_questions: [
                  {
                      question_type: 'currency', name: 'annual_review_revenue_eight_a_sales', position: 1, title: 'Revenue from 8(a) sales'
                  },
                  {
                      question_type: 'currency', name: 'annual_review_revenue_non_eight_a_sales', position: 2, title: 'Revenue from non-8(a) sales'
                  },
                  {
                      question_type: 'date', name: 'annual_review_fiscal_year', position: 3, title: 'When did your <span style=\"font-weight: bolder;\">PROGRAM YEAR</span> end?'
                  }
              ]
            end


          end

          review_section 'review', 1, title: 'Review', submit_text: 'Submit'
        end
        Section.where(questionnaire_id: eight_a_annual_review_eligibility.id, name: 'review').update_all is_last: true
      end

      eight_a_annual_review_eligibility.create_rules! do
        section_rule 'eight_a_annual_review_eligibility_update_info', 'eight_a_annual_review_eligibility_explain_changes'
        section_rule 'eight_a_annual_review_eligibility_explain_changes', 'eight_a_annual_review_eligibility_entity_ownership'
        section_rule 'eight_a_annual_review_eligibility_entity_ownership', 'eight_a_annual_review_eligibility_tax_returns'
        section_rule 'eight_a_annual_review_eligibility_tax_returns', 'eight_a_annual_review_eligibility_financials'
        section_rule 'eight_a_annual_review_eligibility_financials', 'eight_a_annual_review_eligibility_revenue'
        section_rule 'eight_a_annual_review_eligibility_revenue', 'review'
      end

      q = Question.find_by(name: 'explain_changes')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of Incorporation amendments").id

      q = Question.find_by(name: 'integrity_character_changes')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Criminal record narrative").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Criminal court record").id

      q = Question.find_by(name: 'adverse_actions')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Character Document").id

      q = Question.find_by(name: 'entity_owned')
      doc = DocumentType.create!({name: 'SBA Form Benefit Report'})
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: doc.id

      q = Question.find_by(name: 'annual_review_tax_returns')
      doc = DocumentType.create!({name: 'Business tax returns'})
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: doc.id

      q = Question.find_by(name: 'annual_review_financials')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Balance Sheet").id
      doc = DocumentType.create!({name: 'Financial statements'})
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: doc.id
    end

  end
end