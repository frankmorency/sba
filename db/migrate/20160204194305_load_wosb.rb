class LoadWosb < ActiveRecord::Migration
  def change
    wosb = Questionnaire.create! name: 'wosb', title: 'WOSB Application', anonymous: false
    wosb.evaluation_purposes.create! name: 'wosb_certification', title: 'Women Owned Small Business', certificate_type: CertificateType.get('wosb')
    CertificateType.get('wosb').update_attribute(:questionnaire_id, wosb.id)

    wosb.create_sections! do
      root 's_wosb_2413', 1, title: 'WOSB Application' do
        question_section 'pc', 0, title: 'Prior Certification' do
          question_section '8a', 1, title: '8(a)', first: true do
            yesno_with_attachment_required_on_yes '8aq1', 1, title: 'The concern is currently certified by the U.S. Small Business Administration as an 8(a) Business Development (BD) Program Participant and the 51% owner is a woman or women, or an economically disadvantaged woman or women. ',
                                                  positive_response: { wosb_certification: 'yes' }

          end
          question_section 'third_party_cert', 2, title: 'Third Party Certification' do
            question_section 'third_party_cert_part_1', 1, title: 'Third Party' do
              yesno_with_attachment_required_on_yes 'tpc1_q1', 1, title: 'The concern is certified as a WOSB or EDWOSB in accordance with Section 8(m) of the Small Business Act, by an SBA-approved third-party certifier.',
                                                    positive_response: { wosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_2', 2, title: 'Changes in Eligibility' do
              yesno 'tpc2_q1', 1, title: 'Since the date of the firm’s receipt of a decision by an SBA-approved third-party certifier affirming its eligibility as a WOSB or EDWOSB in accordance with Section 8(m) of the Small Business Act, there have been no changes in circumstance affecting the concern’s eligibility.',
                    positive_response: { wosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_3', 3, title: 'Non-qualification' do
              yesno_with_attachment_required_on_yes 'tpc3_q1', 1, title: 'The concern is in receipt of a decision by an SBA-approved third-party certifier that the concern does not qualify as a WOSB or EDWOSB in accordance with Section 8(m) of the Small Business Act.',
                                                    positive_response: { wosb_certification: 'yes' }
            end
          end
        end
        question_section 'business', 3, title: 'Business' do
          question_section 'corporation', 1, title: 'Corporation & S-Corp' do
            question_section 'corp1', 1, title: 'Stocks' do
              yesno_with_comment_on_no_required_with_attachment_on_yes_required 'corp1_q1', 1, title: 'Does the corporation\'s stock ledger and stock certificates evidence that women own at least 51% of all outstanding stock?',
                                                                                positive_response: {wosb_certification: 'yes'}
              yesno 'corp1_q2', 2, title: 'Does the corporation have more than one class of voting stock?',
                    positive_response: {wosb_certification: 'yes'}
              yesno 'corp1_q3', 3, title: 'In answering question 1 and 2 did you consider the stock options or similar agreements held by women to be exercised?',
                    positive_response: {wosb_certification: 'yes'}
            end
            question_section 'corp2', 2, title: 'Stock Ownership' do
              yesno 'corp2_q1', 1, title: 'Do the corporation\'s stock ledger and stock certificates evidence that at least 51% of each class of voting stock is owned by women?',
                    positive_response: {wosb_certification: 'yes'}
            end
            question_section 'corp3', 3, title: 'Corporation Ownership' do
              yesno 'corp3_q1', 1, title: 'Does the corporation have any unexercised stock options or similar agreements?',
                    positive_response: {wosb_certification: 'yes'}
            end
            question_section 'corp4', 4, title: 'Women Ownership' do
              yesno 'corp4_q1', 1, title: 'Are any unexercised stock options or similar agreements held by women?',
                    positive_response: {wosb_certification: 'yes'}
            end
            question_section 'corp5', 5, title: 'Ownership & Control' do
              yesno_with_comment_on_no_required_with_attachment_on_yes_required 'corp5_q1', 1, title: 'If a corporation, the articles of incorporation and any amendments, articles of conversion, by-laws and amendments, shareholder meeting minutes showing director elections, shareholder meeting minutes showing officer elections, organizational meeting minutes, all issued stock certificates, stock ledger, buy-sell agreements, stock transfer agreements, voting agreements, and documents relating to stock options, including the right to convert non-voting stock or debentures into voting stock evidence that one or more women or economically disadvantaged women control the Board of Directors of the concern. \n \nWomen are considered to control the Board of Directors when either: (1) one or more women or economically disadvantaged women own at least 51% of all voting stock of the concern, are on the Board of Directors and have the percentage of voting stock necessary to overcome any super majority voting requirements; or (2) women or economically disadvantaged women comprise the majority of voting directors through actual numbers or, where permitted by state law, through weighted voting.
',
                                                                                positive_response: {wosb_certification: 'yes'}
            end
          end
          question_section 'partnership', 2, title: 'Partnership' do
            yesno_with_comment_on_no_required_with_attachment_on_yes_required 'partn_q1', 1, title: 'If a partnership, the partnership agreement evidences that at least 51% of each class of partnership interest is unconditionally and directly owned by one or more women, or economically disadvantaged women.',
                                                                              positive_response: {wosb_certification: 'yes'}
            yesno_with_comment_on_no_required_with_attachment_on_yes_required 'partn_q2', 2, title: 'If a partnership, the partnership agreement evidences that one or more women or economically disadvantaged women serve as general partners, with control over all partnership decisions.',
                                                                              positive_response: {wosb_certification: 'yes'}
          end
          question_section 'llc', 3, title: 'LLC' do
            yesno_with_comment_on_no_required_with_attachment_on_yes_required 'llc_q1', 1, title: 'If a limited liability company, the articles of organization and any amendments, and operating agreement and amendments, evidence that at least 51% of each class of member interest is unconditionally and directly owned by one or more women or economically disadvantaged women.',
                                                                              positive_response: {wosb_certification: 'yes'}
            yesno_with_comment_on_no_required_with_attachment_on_yes_required 'llc_q2', 2, title: 'If a limited liability company, the articles of organization and any amendments, and operating agreement and amendments evidence that one or more women or economically disadvantaged women serve as management members, with control over all decisions of the limited liability company.',
                                                                              positive_response: {wosb_certification: 'yes'}
          end
        end
        question_section 'operations', 4, title: 'Operations' do
          question_section 'operations_part_1', 1, title: 'Citizenship & Ownership' do
            yesno_with_attachment_required_on_yes 'oper1_q1', 1, title: 'The birth certificates, naturalization papers, or passports for owners who are women or economically disadvantaged women show that the business concern is at least 51% owned and controlled by women or economically disadvantaged women who are U.S. citizens.',
                                                  positive_response: {wosb_certification: 'yes'}
            yesno 'oper1_q2', 2, title: 'The ownership by women or economically disadvantaged women is not subject to any conditions, executory agreements, voting trusts, or other arrangements that cause or potentially cause ownership benefits to go to another.',
                  positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_2', 2, title: 'Businesses & Trusts' do
            yesno 'oper2_q1', 1, title: 'The 51% ownership by women or economically disadvantaged women is not through another business entity (including employee stock ownership plan) that is, in turn, owned and controlled by one or more women.',
                  positive_response: {wosb_certification: 'yes'}
            yesnona_with_comment_required 'oper2_q2', 2, title: 'The 51% ownership by women or economically disadvantaged women is held through a trust, the trust is revocable, and the woman or economically disadvantaged woman is the grantor, a trustee, and the sole current beneficiary of the trust.',
                                          positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_3', 3, title: 'Operations & Management' do
            yesno 'oper3_q1', 1, title: 'The management and daily business operations of the concern are controlled by one or more women, or economically disadvantaged women. Control means that both the long-term decision making and the day-to-day management and administration of the business operations are conducted by one or more women or economically disadvantaged women.',
                  positive_response: {wosb_certification: 'yes'}
            yesno 'oper3_q2', 2, title: 'A woman or economically disadvantaged woman holds the highest officer position in the concern and her resume evidences that she has the managerial experience of the extent and complexity needed to run the concern.',
                  positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_4', 4, title: 'Expertise & Employment' do
            yesno 'oper4_q1', 1, title: 'The woman or economically disadvantaged woman manager does not have the technical expertise or possess the required license for the business but has ultimate managerial and supervisory control over those who possess the required licenses or technical expertise.',
                  positive_response: {wosb_certification: 'yes'}
            yesno 'oper4_q2', 2, title: 'The woman or economically disadvantaged woman who holds the highest officer position of the concern manages it on a full-time basis and devotes full-time to the business concern during the normal working hours of business concerns in the same or similar line of business.',
                  positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_5', 5, title: 'Highest Officer & Control' do
            yesno 'oper5_q1', 1, title: 'The woman or economically disadvantaged woman who holds the highest officer position does not engage in outside employment that prevents her from devoting sufficient time and attention to the daily affairs of the concern to control its management and daily business operations.',
                  positive_response: {wosb_certification: 'yes'}
            yesno 'oper5_q2', 2, title: 'No males or other entity exercise actual control or have the power to control the concern.',
                  positive_response: {wosb_certification: 'yes'}
          end
          question_section 'operations_part_6', 6, title: 'SBA Exam & Daily Operations' do
            yesno 'oper6_q1', 1, title: 'SBA, in connection with an examination or protest, has not issued a decision currently in effect finding that this business concern does not qualify as a WOSB or an EDWOSB.',
                  positive_response: {wosb_certification: 'yes'}
            yesno_with_comment_required_on_no 'oper6_q2', 2, title: 'Can the owner certify that they are in control of the day-to-day operations?',
                                              positive_response: {wosb_certification: 'yes'}
          end
        end
        review_section 'review', 5, title: 'Review', submit_text: "Accept"
        signature_section 'signature', 6, title: 'Signature'
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
      section_rule 'third_party_cert_part_2', 'corp1', [
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
      section_rule 'third_party_cert_part_3', 'corp1', {
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

      section_rule 'corp1', 'corp2', {
          klass: 'Answer', identifier: 'corp1_q2', value: 'yes'
      }
      section_rule 'corp1', 'corp3', {
          klass: 'Answer', identifier: 'corp1_q2', value: 'no'
      }
      section_rule 'corp2', 'corp3'
      section_rule 'corp3', 'corp4', {
          klass: 'Answer', identifier: 'corp3_q1', value: 'yes'
      }
      section_rule 'corp3', 'corp5', {
          klass: 'Answer', identifier: 'corp3_q1', value: 'no'
      }
      section_rule 'corp4', 'corp5'
      section_rule 'corp5', 'operations_part_1'
      section_rule 'llc', 'operations_part_1'
      section_rule 'partnership', 'operations_part_1'
      section_rule 'operations_part_1', 'operations_part_2'
      section_rule 'operations_part_2', 'operations_part_3'
      section_rule 'operations_part_3', 'operations_part_4'
      section_rule 'operations_part_4', 'operations_part_5'
      section_rule 'operations_part_5', 'operations_part_6'
      section_rule 'operations_part_6', 'review'
      section_rule 'review', 'signature'
    end
  end
end