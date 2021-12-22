class LoadNewWosb < ActiveRecord::Migration
  def change
    
    Questionnaire.get('wosb').update_attribute :name, 'wosb_v_one'

    wosb = Questionnaire::SimpleQuestionnaire.create! name: 'wosb', title: 'WOSB Application', anonymous: false, program: Program.get('wosb'), review_page_display_title: "Women-Owned Small Business Program Self-Certification Summary", human_name: 'WOSB', link_label: "WOSB Self-Certification"
    cert_type = CertificateType.get('wosb')
    wosb.update_attributes(certificate_type_id: cert_type.id, initial_app: true)
    evaluation_purpose = EvaluationPurpose.find_by_name('wosb_certification')
    evaluation_purpose.update_attribute(:questionnaire_id, wosb.id)

    wosb.create_sections! do
      root 's_wosb_2413', 1, title: 'WOSB Application' do
        question_section 'pc', 1, title: 'Prior Certifications' do
          question_section '8a', 1, title: '8(a)', first: true do
            question '8aq1', 1, positive_response: { wosb_certification: 'yes' }
          end
          question_section 'third_party_cert', 2, title: 'Third Party Certification' do
            question_section 'third_party_cert_part_1', 1, title: 'Third Party' do
              question 'tpc1_q1', 1, positive_response: { wosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_2', 2, title: 'Changes in Eligibility' do
              question 'tpc2_q1', 1, positive_response: { wosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_3', 3, title: 'Non-qualification' do
              question 'tpc3_q1', 1, positive_response: { wosb_certification: 'yes' }
            end
          end
        end
        question_section 'business', 2, title: 'Business' do
          question_section 'corporation', 1, title: 'Corporation & S-Corp' do
            question 'corp1_q1', 1, positive_response: {wosb_certification: 'yes'}
            question 'corp1_q2', 2, positive_response: {wosb_certification: 'yes'}
            question 'corp2_q1', 3, positive_response: {wosb_certification: 'yes'}
            question 'corp1_q3', 4, positive_response: {wosb_certification: 'yes'}
            question 'corp3_q1', 5, positive_response: {wosb_certification: 'yes'}
            question 'corp4_q1', 6, positive_response: {wosb_certification: 'yes'}
            question 'corp5_q1', 7, positive_response: {wosb_certification: 'yes'}
          end
          question_section 'partnership', 2, title: 'Partnership' do
            question 'partn_q1', 1, positive_response: {wosb_certification: 'yes'}
            question 'partn_q2', 2, positive_response: {wosb_certification: 'yes'}
          end
          question_section 'llc', 3, title: 'LLC' do
            question 'llc_q1', 1, positive_response: {wosb_certification: 'yes'}
            question 'llc_q2', 2, positive_response: {wosb_certification: 'yes'}
          end
        end
        question_section 'operations', 3, title: 'Control' do
          question_section 'operations_part_1', 1, title: 'Citizenship' do
            question 'oper1_q1', 1, positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_2', 2, title: 'Ownership' do
            question 'oper1_q2', 1, positive_response: {wosb_certification: 'yes'}
            question 'oper2_q1', 2, positive_response: {wosb_certification: 'yes'}
            question 'oper2_q2', 3, positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_3', 3, title: 'Management' do
            question 'oper3_q1', 1, positive_response: {wosb_certification: 'yes'}
            question 'oper3_q2', 2, positive_response: {wosb_certification: 'yes'}
            question 'oper4_q1', 3, positive_response: {wosb_certification: 'yes'}
            question 'oper4_q2', 4, positive_response: {wosb_certification: 'yes'}
            question 'oper5_q2', 5, positive_response: {wosb_certification: 'yes'}
            question 'oper6_q2', 6, positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_6', 4, title: 'SBA Exam' do
            question 'oper6_q1', 1, positive_response: {wosb_certification: 'yes'}
          end
        end
        review_section 'review', 100, title: 'Review', submit_text: "Accept"
        signature_section 'signature', 101, title: 'Signature'
      end
    end

    wosb.create_rules! do
      section_rule '8a', 'review', {
          klass: 'Answer', identifier: '8aq1', value: 'yes'
      }
      section_rule '8a', 'third_party_cert_part_1', {
          klass: 'Answer', identifier: '8aq1', value: 'no'
      }
      section_rule 'third_party_cert_part_1', 'third_party_cert_part_2', {
          klass: 'Answer', identifier: 'tpc1_q1', value: 'yes'
      }
      section_rule 'third_party_cert_part_1', 'third_party_cert_part_3', {
          klass: 'Answer', identifier: 'tpc1_q1', value: 'no'
      }
      section_rule 'third_party_cert_part_2', 'signature', {
          klass: 'Answer', identifier: 'tpc2_q1', value: 'no'
      }
      section_rule 'third_party_cert_part_2', 'corporation', [
          {
              klass: 'Answer', identifier: 'tpc2_q1', value: 'yes'
          }, {
              klass: 'Organization', field: 'business_type', operation: 'equal', value: ['corp', 's-corp']
          }
      ]
      section_rule 'third_party_cert_part_2', 'llc', [
          {
              klass: 'Answer', identifier: 'tpc2_q1', value: 'yes'
          }, {
              klass: 'Organization', field: 'business_type', operation: 'equal', value: 'llc'
          }
      ]
      section_rule 'third_party_cert_part_2', 'partnership', [
          {
              klass: 'Answer', identifier: 'tpc2_q1', value: 'yes'
          }, {
              klass: 'Organization', field: 'business_type', operation: 'equal', value: 'partnership'
          }
      ]
      section_rule 'third_party_cert_part_2', 'operations_part_1', [
          {
              klass: 'Answer', identifier: 'tpc2_q1', value: 'yes'
          }, {
              klass: 'Organization', field: 'business_type', operation: 'not_equal', value: ['corp', 's-corp', 'llc', 'partnership']
          }
      ]
      section_rule 'third_party_cert_part_3', 'corporation', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: ['corp', 's-corp']
      }
      section_rule 'third_party_cert_part_3', 'llc', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: 'llc'
      }
      section_rule 'third_party_cert_part_3', 'partnership', {
          klass: 'Organization', field: 'business_type', operation: 'equal', value: 'partnership'
      }
      section_rule 'third_party_cert_part_3', 'operations_part_1', {
          klass: 'Organization', field: 'business_type', operation: 'not_equal', value: ['corp', 's-corp', 'llc', 'partnership']
      }
      section_rule 'corporation', 'operations_part_1'
      section_rule 'llc', 'operations_part_1'
      section_rule 'partnership', 'operations_part_1'
      section_rule 'operations_part_1', 'operations_part_2'
      section_rule 'operations_part_2', 'operations_part_3'
      section_rule 'operations_part_3', 'operations_part_6'
      section_rule 'operations_part_6', 'review'
      section_rule 'review', 'signature'
    end

    cert_type.current_questionnaires.destroy_all
    cert_type.current_questionnaires.create!(kind: 'initial', questionnaire: wosb)
    cert_type.current_questionnaires.create!(kind: 'annual_review', questionnaire: wosb)
  end
end
