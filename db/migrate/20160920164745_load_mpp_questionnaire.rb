class LoadMppQuestionnaire < ActiveRecord::Migration
  def change

    CertificateType.create!(name: 'mpp', title: 'Mentor Protégé Program')
    Questionnaire.reset_column_information
    QuestionPresentation.reset_column_information

    mpp = Questionnaire.create! name: 'mpp', title: 'MPP Application', anonymous: false, program: Program.get('mpp')
    # mpp.evaluation_purposes.create! name: 'mpp_certification', title: 'Mentor Protégé Program', certificate_type: CertificateType.get('mpp')

    CertificateType.get('mpp').update_attribute(:questionnaire_id, mpp.id)

    mpp.create_sections! do
      root 'mpp', 1, title: 'MPP Application' do
        question_section 'requirements', 0, title: 'Requirements' do
          question_section 'eight_a_participants', 0, title: '8(a) Participants', first: true, submit_text: 'Save and continue' do
            yesno_with_attachment_required_on_yes '8a_certified', 1, title: 'Are you an existing 8(a) firm in your final 6 months of the program, wishing to transfer your Mentor-Protégé relationship to the All Small Mentor-Protégé Program?'
          end
          question_section 'eligibility', 1, title: 'Eligibility', submit_text: 'Save and continue' do
            yesno 'for_profit_or_ag_coop', 0, title: 'Are you either a for-profit business or an agricultural cooperative?', disqualifier: {value: 'no', message: 'To qualify for the All Small Mentor-Protégé program, the Protégé must be organized as for-profit businesses. The only exception is if the Protégé is an agricultural cooperative.'}
            yesno 'mentor_for_profit', 1, title: 'Is your Mentor a for-profit business?', disqualifier: {value: 'no', message: 'To qualify for the All Small Mentor-Protégé program, the Mentor must be organized as for-profit businesses.'}
            yesno 'prior_sba_mpp_determination', 2, title: 'Has the SBA ever made a determination of affiliation between you and the Mentor?', disqualifier: {value: 'yes', message: 'If the SBA has previously determined an affiliation between you and your Mentor, you do not qualify for the All Small Mentor-Protégé program.'}
            yesno 'mentor_over_40_percent_protege', 3, title: 'Does the Mentor own or plan to own more than 40 percent equity interest in your firm?', disqualifier: {value: 'yes', message: 'To participate in the All Small Mentor-Protégé Program, the Mentor cannot own more than 40% equity interest in your business.'}
          end
          question_section 'naics_code', 2, title: 'NAICS Code', submit_text: 'Save and continue' do
            naics_code 'mpp_naics_code', 0, title: 'Please select the NAICS code for which you are creating a mentor-protégé relationship:'
            yesno 'prior_naics_code_work', 1, title: 'Have you performed work in the NAICS code in which you’re requesting business development assistance?', disqualifier: {value: 'no', message: 'If you don’t have prior experience in the NAICS code in which you’re seeking business development assistance, SBA will not approve the Mentor-Protégé relationship.'}
            yesno 'small_for_mpp_naics_code', 2, title: 'Are you considered small for the NAICS code in which you’re requesting business development assistance?', disqualifier: {value: 'no', message: 'To participate in the All Small Mentor-Protégé Program, you must qualify as small for the NAICS code in which you are seeking business development assistance.'}
          end
          question_section 'size', 3, title: 'Company Size' do
            question_section 'size_determination', 0, title: 'Size Determination', submit_text: 'Save and continue' do
              yesno 'size_determination', 0, title: 'Have you ever received a size determination letter from the SBA that found you to be “other than small” in the NAICS code in which you’re requesting business development assistance?'
            end
            question_section 'size_redetermination', 1, title: 'Size Redetermination', submit_text: 'Save and continue' do
              yesno 'have_redetermination_letter', 0, title: 'Have you received a size redetermination letter from the SBA that subsequently found you to be small in that NAICS code?', disqualifier: {value: 'no', message: 'If you’ve been found to be “other than small” for the NAICS code in which you’re requesting business development assistance, you need a size redetermination letter from the SBA to qualify for the All Small Mentor-Protégé Program.'}
            end
            question_section 'redetermination_info', 2, title: 'Redetermination Info', submit_text: 'Save and continue' do
              null_with_attachment_required 'redetermination_letter', 0, title: 'Please upload the size redetermination letter issued by SBA.'
              picklist 'sba_area_office', 1, title: 'Which SBA area office sent the letter?', possible_values: ['SBA Area Office 1', 'SBA Area Office 2', 'SBA Area Office 3', 'SBA Area Office 4', 'SBA Area Office 5', 'SBA Area Office 6', 'SBA Headquarters']
              date 'redetermination_date', 2, title: 'What is the determination date stated in the letter?'
            end
          end
        end
        question_section 'protege_info', 1, title: 'Protégé Information' do
          question_section 'protege_training', 0, title: 'Training', submit_text: 'Save and continue' do
            null_with_attachment_required 'mpp_completion_cert', 0, title: 'Please view the Mentor-Protégé Program training module and upload the certificate of completion.'
          end

          question_section 'protege_biz_info', 1, title: 'Business Info' do
            question_section 'protege_general_biz', 0, title: 'Plans and Agreements', submit_text: 'Save and continue' do
              null_with_attachment_required 'protege_biz_plan', 0, title: 'Please upload the Protégé’s business plan.'
              yesno 'other_active_mpp_agreements', 1, title: 'Do you have any active Mentor-Protégé Agreements with the SBA or another federal agency, either as a protégé, or as a mentor to another business?'
            end
            repeating_question_section 'protege_active_agreements', 1, title: 'Active Agreements', submit_text: 'Save and continue' do
              repeating_question 'protege_active_agreements', 0, title: 'Please describe any active agreements in which you are involved.', multi: true, repeater_label: 'Agreement', sub_questions: [
                  {
                      question_type: 'picklist', name: 'mpp_agreement_role', position: 0, title: 'What is your role in the agreement?', possible_values: %w(Mentor Protégé)
                  },
                  {
                      question_type: 'picklist', name: 'mpp_agreement_agency', position: 1, title: 'Through which agency is this agreement established?', possible_values: ['Department of Defense', 'Department of Energy', 'Department of Homeland Security', 'Department of Transportation', 'Department of Treasury', 'Department of Veterans Affairs', 'General Services Administration', 'National Aeronautics and Space Administration', 'Small Business Administration', 'U.S. Agency for International Development']
                  },
                  {
                      question_type: 'date', name: 'mpp_agreement_date', position: 2, title: 'What is the effective date of the agreement?'
                  },
                  {
                      question_type: 'text_field_single_line', name: 'mpp_aggreement_biz', position: 3, title: 'What is the name of the other business involved in the agreement?'
                  },
                  {
                      question_type: 'naics_code', name: 'mpp_agreement_naics', position: 4, title: 'Please select the NAICS code for which the mentor-protégé relationship was established.'
                  }
              ]
            end
            question_section 'protege_active_agreement_docs', 2, title: 'Active Agreement Documents', submit_text: 'Save and continue' do
              null_with_attachment_required 'mpp_active_agreemets', 1, title: 'Please upload copies of the active agreements in which you are involved and any other applicable documentation.'
            end
          end

          question_section 'mpp_agreement', 2, title: 'MPP Agreement', submit_text: 'Save and continue' do
            null_with_attachment_required 'mpp_agreement', 0, title: 'Please upload the written Mentor-Protégé Agreement signed and dated by both the Mentor and the Protégé.'
          end
          question_section 'protege_needs', 3, title: 'Protégé Needs' do
            question_section 'protege_general_needs', 0, title: 'Determine Needs', submit_text: 'Save and continue' do
              yesno 'mpp_providing_mgmt_and_tech', 0, title: 'Will the Mentor be providing the Protégé with “Management and Technical” assistance?'
              yesno 'mpp_providing_financial', 1, title: 'Will the Mentor be providing the Protégé with “Financial” assistance?'
              yesno 'mpp_providing_contracting', 2, title: 'Will the Mentor be providing the Protégé with “Contracting” assistance?'
              yesno 'mpp_providing_trade_ed', 3, title: 'Will the Mentor be providing the Protégé with “Trade Education” assistance?'
              yesno 'mpp_providing_biz_dev', 4, title: 'Will the Mentor be providing the Protégé with “Business Development” assistance?'
              yesno 'mpp_providing_gen_admin', 5, title: 'Will the Mentor be providing the Protégé with “General and/or Administrative” assistance?'
            end
            question_section 'management_and_tech', 1, title: 'Management/Technical Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue' do
              text_field_multiline 'mandt_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'mandt_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'mandt_timeline', 2, title: 'What are the details of the timeline for accomplishing this need within the Mentor-Protégé relationship?'
              text_field_multiline 'mandt_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end
            question_section 'financial', 2, title: 'Financial Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue' do
              text_field_multiline 'financial_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'financial_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'financial_timeline', 2, title: 'What are the details of the timeline for accomplishing this need within the Mentor-Protégé relationship?'
              text_field_multiline 'financial_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end
            question_section 'contracting', 3, title: 'Contracting Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue' do
              text_field_multiline 'contracting_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'contracting_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'contracting_timeline', 2, title: 'What are the details of the timeline for  this need within the Mentor-Protégé relationship?'
              text_field_multiline 'contracting_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end
            question_section 'trade_education', 4, title: 'Trade Education Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue' do
              text_field_multiline 'ed_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'ed_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'ed_timeline', 2, title: 'What are the details of the timeline for accomplishing this need within the Mentor-Protégé relationship?'
              text_field_multiline 'ed_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end
            question_section 'business_dev', 5, title: 'Business Development Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue' do
              text_field_multiline 'bd_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'bd_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'bd_timeline', 2, title: 'What are the details of the timeline for accomplishing this need within the Mentor-Protégé relationship?'
              text_field_multiline 'bd_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end
            question_section 'general_admin', 6, title: 'General/Administrative Needs', defer_applicability_for: 'protege_general_needs', submit_text: 'Save and continue'  do
              text_field_multiline 'ga_needs', 0, title: 'What are your needs within the selected area?'
              text_field_multiline 'ga_activities', 1, title: 'What activities is the Mentor going to do to support this need within the Mentor-Protégé relationship?'
              text_field_multiline 'ga_timeline', 2, title: 'What are the details of the timeline for accomplishing this need within the Mentor-Protégé relationship?'
              text_field_multiline 'ga_success', 3, title: 'How will success be measured for this need within the Mentor-Protégé relationship?'
            end

          end
        end
        question_section 'mentor_info', 2, title: 'Mentor Information' do
          question_section 'mentor_training', 0, title: 'Training', submit_text: 'Save and continue' do
            null_with_attachment_required 'mentor_mpp_training_cert', 0, title: 'Please upload the Mentor’s certificate of completion for the Mentor-Protégé Program training module.'
          end
          question_section 'mentor_business_info', 1, title: 'Business Info', submit_text: 'Save and continue' do
            duns 'mpp_duns', 0, title: 'Please provide the Mentor’s DUNS number:'
          end
        end
        review_section 'review', 3, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 4, title: 'Signature', submit_text: 'Accept'
      end
    end

    mpp.create_rules! do
      section_rule 'eight_a_participants', 'review', {
          klass: 'Answer', identifier: '8a_certified', value: 'yes'
      }
      section_rule 'eight_a_participants', 'eligibility', {
          klass: 'Answer', identifier: '8a_certified', value: 'no'
      }
      section_rule 'eligibility', 'naics_code', [
          {
              klass: 'Answer', identifier: 'for_profit_or_ag_coop', value: 'yes'
          },
          {
              klass: 'Answer', identifier: 'mentor_for_profit', value: 'yes'
          },
          {
              klass: 'Answer', identifier: 'prior_sba_mpp_determination', value: 'no'
          },
          {
              klass: 'Answer', identifier: 'mentor_over_40_percent_protege', value: 'no'
          }
      ]
      section_rule 'eligibility', 'review', {
          klass: 'Answer', identifier: 'for_profit_or_ag_coop', value: 'no'
      }
      section_rule 'eligibility', 'review', {
          klass: 'Answer', identifier: 'mentor_for_profit', value: 'no'
      }
      section_rule 'eligibility', 'review', {
          klass: 'Answer', identifier: 'prior_sba_mpp_determination', value: 'yes'
      }
      section_rule 'eligibility', 'review', {
          klass: 'Answer', identifier: 'mentor_over_40_percent_protege', value: 'yes'
      }
      section_rule 'eligibility', 'review', {
          klass: 'Answer', identifier: 'for_profit_or_ag_coop', value: 'no'
      }
      section_rule 'naics_code', 'size_determination', [
          {
              klass: 'Answer', identifier: 'prior_naics_code_work', value: 'yes'
          },
          {
              klass: 'Answer', identifier: 'small_for_mpp_naics_code', value: 'yes'
          }
      ]
      section_rule 'naics_code', 'review', {
          klass: 'Answer', identifier: 'prior_naics_code_work', value: 'no'
      }
      section_rule 'naics_code', 'review', {
          klass: 'Answer', identifier: 'small_for_mpp_naics_code', value: 'no'
      }
      section_rule 'naics_code', 'review', [
          {
              klass: 'Answer', identifier: 'small_for_mpp_naics_code', value: 'no'
          },
          {
              klass: 'Answer', identifier: 'prior_naics_code_work', value: 'no'
          }
      ]
      section_rule 'size_determination', 'size_redetermination', {
          klass: 'Answer', identifier: 'size_determination', value: 'yes'
      }
      section_rule 'size_determination', 'protege_training', {
          klass: 'Answer', identifier: 'size_determination', value: 'no'
      }
      section_rule 'size_redetermination', 'redetermination_info', {
          klass: 'Answer', identifier: 'have_redetermination_letter', value: 'yes'
      }
      section_rule 'size_redetermination', 'review', {
          klass: 'Answer', identifier: 'have_redetermination_letter', value: 'no'
      }
      section_rule 'redetermination_info', 'protege_training'
      section_rule 'protege_training', 'protege_general_biz'

      section_rule 'protege_general_biz', 'protege_active_agreements', {
          klass: 'Answer', identifier: 'other_active_mpp_agreements', value: 'yes'
      }
      section_rule 'protege_general_biz', 'mpp_agreement', {
          klass: 'Answer', identifier: 'other_active_mpp_agreements', value: 'no'
      }

      section_rule 'protege_active_agreements', 'protege_active_agreement_docs'
      section_rule 'protege_active_agreement_docs', 'mpp_agreement'
      section_rule 'mpp_agreement', 'protege_general_needs'

      section_rule 'protege_general_needs', 'mentor_training', klass: 'MultiPath', rules: [
              {
                  'management_and_tech': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_mgmt_and_tech',
                      value: 'yes'
                  }
              },
              {
                  'financial': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_financial',
                      value: 'yes'
                  }
              },
              {
                  'contracting': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_contracting',
                      value: 'yes'
                  }
              },
              {
                  'trade_education': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_trade_ed',
                      value: 'yes'
                  }
              },
              {
                  'business_dev': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_biz_dev',
                      value: 'yes'
                  }
              },
              {
                  'general_admin': {
                      klass: 'Answer',
                      identifier: 'mpp_providing_gen_admin',
                      value: 'yes'
                  }
              }
          ]

      section_rule 'mentor_training', 'mentor_business_info'
      section_rule 'mentor_business_info', 'review'
      section_rule 'review', 'signature'
    end
  end
end
