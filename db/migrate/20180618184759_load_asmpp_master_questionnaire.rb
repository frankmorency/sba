class LoadAsmppMasterQuestionnaire < ActiveRecord::Migration
  def change
    cert_type = CertificateType.get('asmpp')

    asmpp_eligibility = Questionnaire::SubQuestionnaire.create! name: 'asmpp_eligibility', title: 'Basic Eligibility', anonymous: false, program: Program.get('asmpp'), review_page_display_title: 'Eligibility Summary', prerequisite_order: 0
    asmpp_eligibility.create_sections! do
      root 'asmpp_eligibility_root', 1, title: 'Basic Eligibility' do
        question_section 'asmpp_eight_a_participation', 1, title: '8(a) Participation', submit_text: 'Save and continue', first: true do
          yesno_with_attachment_required_on_yes 'asmpp_eligibility_participation', 0, title: 'Is your firm an active 8(a) firm seeking to transfer your existing mentor-protégé relationship to the All Small Mentor-Protégé Program?'
        end
        question_section 'asmpp_eligibility', 2, title: 'Basic Eligibility' do
          question_section 'asmpp_general_assessment', 1, title: 'General Assessment', submit_text: 'Save  and continue' do
            yesno 'asmpp_eligibility_for_profit_or_ag', 0, title: 'Is your firm a for-profit business or an agricultural cooperative?', disqualifier: {value: 'no', message: 'To qualify for the All Small Mentor-Protégé program, the Protégé must be organized as for-profit businesses. The only exception is if the Protégé is an agricultural cooperative.'}
            yesno 'asmpp_eligibility_mentor_for_profit', 1, title: 'Is your mentor a for-profit business?', disqualifier: {value: 'no', message: 'To qualify for the All Small Mentor-Protégé program, the Mentor must be organized as a for-profit businesses.'}
            yesno 'asmpp_eligibility_prior_affiliation_determination', 2, title: 'Has the SBA ever determined that you and your mentor are affiliated?', disqualifier: {value: 'yes', message: 'If the SBA has previously determined an affiliation between you and your Mentor, you do not qualify for the All Small Mentor-Protégé program.'}
          end
          question_section 'asmpp_affiliation', 2, title: 'Affiliation', submit_text: 'Save and continue' do
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_equity_ownership', 0, title: "Does your mentor firm, or any of its equity owners, own any of your firm’s equity or have the right to own equity in your firm (including stock options or convertible securities)?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_stock_agreement', 1, title: "Do you and your mentor have an agreement or an agreement in principle to merge or sell stock to the other?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_mentor_position', 2, title: "Do any of your mentor firm’s officers, directors, managing members, partners, principal stockholders, or employees also hold a position in your firm as an officer, director, managing member, partner, principal stockholder, or employee?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_mentor_family_member', 3, title: "Do any of your mentor firm’s owners or managers have a family member that is an owner or manager for your firm?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_common_investment', 4, title: "Does your mentor firm or any of its owners or managers have investments in common with your firm or any of your firm’s owners or managers?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_mentor_receipts', 5, title: "Based on the previous three fiscal years, does your firm derive 70% or more of its receipts from your mentor?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_joint_venture', 6, title: "Have your firm and your mentor firm formed a joint venture that has 1.) received multiple contract awards more than two years apart or 2.) received more than three contract awards?"
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_franchise_agreement', 7, title: "Does your firm have a franchise or license agreement with your mentor?"
          end
          question_section 'asmpp_naics_code', 3, title: 'NAICS Code', submit_text: 'Save and continue' do
            naics_code 'asmpp_eligibility_naics_code', 0, title: 'Select the NAICS code for which you are creating a mentor-protégé relationship:'
            yesno_with_attachment_required_on_yes 'asmpp_eligibility_naics_code_work', 1, title: 'Has your firm performed work in the NAICS code you are requesting business development assistance for?', disqualifier: {value: 'no', message: 'If you don’t have prior experience in the NAICS code in which you’re seeking business development assistance, SBA will not approve the Mentor-Protégé relationship.'}
            yesno 'asmpp_eligibility_considered_small', 2, title: 'Is your firm considered small for the NAICS code in which you are requesting business development?', disqualifier: {value: 'no', message: 'To participate in the All Small Mentor-Protégé Program, you must qualify as small for the NAICS code in which you are seeking business development assistance.'}
          end
          question_section 'asmpp_company_size', 4, title: 'Company Size', submit_text: 'Save and continue' do
            question_section 'asmpp_size_determination', 1, title: 'Size Determination', submit_text: 'Save and continue' do
              yesno 'asmpp_eligibility_size_determination', 0, title: 'Have you ever received a size determination letter from the SBA stating that your firm is “other than small” in the NAICS code you are requesting business development assistance for?'
            end
            question_section 'asmpp_size_redetermination', 2, title: 'Redetermination of Size', submit_text: 'Save and continue' do
              yesno 'asmpp_eligibility_have_redetermination_letter', 0, title: 'Since receiving the determination letter, have you received a size redetermination letter from the SBA that found your firm to be small in the NAICS code you are requesting business development assistance for?', disqualifier: {value: 'no', message: 'If you’ve been found to be “other than small” for the NAICS code in which you’re requesting business development assistance, you need a size redetermination letter from the SBA to qualify for the All Small Mentor-Protégé Program.'}
            end
            question_section 'asmpp_redetermination_info', 3, title: 'Redetermination Info', submit_text: 'Save and continue' do
              null_with_attachment_required 'asmpp_eligibility_redetermination_letter', 0, title: 'Upload the size redetermination letter that SBA issued your firm.'
              picklist 'sba_area_office', 1, title: 'Which SBA area office sent the letter?', possible_values: ['SBA Area Office 1', 'SBA Area Office 2', 'SBA Area Office 3', 'SBA Area Office 4', 'SBA Area Office 5', 'SBA Area Office 6', 'SBA Headquarters']
              date 'redetermination_date', 2, title: 'What is the determination date stated in the letter?'
            end
          end
        end
        review_section 'review', 5, title: 'Review', submit_text: 'Submit'
      end
    end
    asmpp_eligibility.create_rules! do
      section_rule 'asmpp_eight_a_participation', 'asmpp_general_assessment', {
          klass: 'Answer', identifier: 'asmpp_eligibility_participation', value: 'no'
      }
      section_rule 'asmpp_eight_a_participation', 'review', {
          klass: 'Answer', identifier: 'asmpp_eligibility_participation', value: 'yes'
      }
      section_rule 'asmpp_general_assessment', 'asmpp_affiliation'
      section_rule 'asmpp_affiliation', 'asmpp_naics_code'
      section_rule 'asmpp_naics_code', 'asmpp_size_determination'
      section_rule 'asmpp_size_determination', 'asmpp_size_redetermination', {
          klass: 'Answer', identifier: 'asmpp_eligibility_size_determination', value: 'yes'
      }
      section_rule 'asmpp_size_determination', 'review', {
          klass: 'Answer', identifier: 'asmpp_eligibility_size_determination', value: 'no'
      }

      section_rule 'asmpp_size_redetermination', 'asmpp_redetermination_info',{
          klass: 'Answer', identifier: 'asmpp_eligibility_have_redetermination_letter', value: 'yes'
      }
      section_rule 'asmpp_size_redetermination', 'review',{
          klass: 'Answer', identifier: 'asmpp_eligibility_have_redetermination_letter', value: 'no'
      }

      section_rule 'asmpp_redetermination_info', 'review'
    end

    # Create new docs for asmpp_eligibility subquestionnare
    ['8(a) Transfer Addendum', 'Merger Agreement', 'Organization structure', 'Employment agreements', 'Investment agreements', 'Income statement', 'Franchise agreement', 'License agreement', 'Contract', 'Invoice'].each do |doc_type|
      DocumentType.create! name: doc_type
    end

    # associate docs to asmpp_eligibility questions
    q1 = Question.find_by_name('asmpp_eligibility_participation')
    doc_type1 = DocumentType.find_by_name('8(a) Transfer Addendum')
    doc_type2 = DocumentType.find_by_name('8(a) Mentor-Protégé Agreement')
    doc_type3 = DocumentType.find_by_name('8(a) Mentor-Protégé Approval Letter')

    if q1 && doc_type1 && doc_type2 && doc_type3
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_equity_ownership')
    doc_type1 = DocumentType.find_by_name('Other Ownership Agreement')
    doc_type2 = DocumentType.find_by_name('Operating agreement')
    doc_type3 = DocumentType.find_by_name('Stock Agreements')

    if q1 && doc_type1 && doc_type2 && doc_type3
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_stock_agreement')
    doc_type1 = DocumentType.find_by_name('Merger Agreement')
    doc_type2 = DocumentType.find_by_name('Stock Agreements')

    if q1 && doc_type1 && doc_type2
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_mentor_position')
    doc_type1 = DocumentType.find_by_name('Operating agreement')
    doc_type2 = DocumentType.find_by_name('Organization structure')
    doc_type3 = DocumentType.find_by_name('Partnership agreement')
    doc_type4 = DocumentType.find_by_name('Employment agreements')

    if q1 && doc_type1 && doc_type2 && doc_type3 && doc_type4
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type4.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_mentor_family_member')
    doc_type1 = DocumentType.find_by_name('Other')

    if q1 && doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_common_investment')
    doc_type1 = DocumentType.find_by_name('Investment agreements')

    if q1 && doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_mentor_receipts')
    doc_type1 = DocumentType.find_by_name('Income statement')

    if q1 && doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_joint_venture')
    doc_type1 = DocumentType.find_by_name('Other')

    if q1 && doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_franchise_agreement')
    doc_type1 = DocumentType.find_by_name('Franchise agreement')
    doc_type2 = DocumentType.find_by_name('License agreement')

    if q1 && doc_type1 && doc_type2
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_naics_code_work')
    doc_type1 = DocumentType.find_by_name('Other')
    doc_type2 = DocumentType.find_by_name('Contract')
    doc_type3 = DocumentType.find_by_name('Invoice')

    if q1 && doc_type1 && doc_type2 && doc_type3
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id
    end

    q1 = Question.find_by_name('asmpp_eligibility_redetermination_letter')
    doc_type1 = DocumentType.find_by_name('SBA Size Redetermination Letter')

    if q1 && doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id
    end

    asmpp_protege = Questionnaire::SubQuestionnaire.create! name: 'asmpp_protege', title: 'Protégé Information', anonymous: false, program: Program.get('asmpp'), review_page_display_title: 'Protégé Information'
    asmpp_protege.create_sections! do
      root 'asmpp_protege_root', 1, title: 'Protégé Information' do
        question_section 'asmpp_protege', 1, title: 'Protégé Information' do
          question_section 'asmpp_training', 1, title: 'Training', submit_text: 'Save and continue', first: true do
            null_with_attachment_required 'asmpp_completion_cert', 0, title: 'Complete the online <a href="https://www.sba.gov/course/all-small-mentor-protege-program/" target="_blank" class="usa-external_link">All Small Mentor-Protégé Program training</a> and upload your certificate of completion.'
          end
          question_section 'asmpp_business_info', 2, title: 'Business Info', submit_text: 'Save and continue' do
            question_section 'protege_general_biz', 0, title: 'Plans and Agreements', submit_text: 'Save and continue' do
              null_with_attachment_required 'protege_biz_plan', 0, title: "Upload your firm's business plan, which includes financial projections."
              yesno 'asmpp_other_active_agreements', 1, title: 'Do you have any active Mentor-Protégé Agreements with the SBA or another federal government agency, either as a protégé or a mentor to another firm?'
            end
            repeating_question_section 'asmpp_protege_active_agreements', 1, title: 'Active Agreements', submit_text: 'Save and continue' do
              repeating_question 'asmpp_protege_active_agreements', 0, title: '', multi: true, repeater_label: 'Agreement', sub_questions: [
                {
                    question_type: 'picklist', name: 'asmpp_agreement_role', position: 1, title: "What is your firm’s role in this agreement?", possible_values: %w(Mentor Protégé)
                },
                {
                    question_type: 'picklist', name: 'asmpp_agreement_agency', position: 2, title: 'Which agency sent the approval letter?', possible_values: ['Department of Defense', 'Department of Energy', 'Department of Homeland Security', 'Department of Transportation', 'Department of the Treasury', 'Department of Veterans Affairs', 'General Services Administration', 'National Aeronautics and Space Administration', 'Small Business Administration', 'U.S. Agency for International Development', 'Other']
                },
                {
                    question_type: 'date', name: 'asmpp_agreement_date', position: 3, title: 'What is the determination date stated in the letter?'
                },
                {
                    question_type: 'text_field_single_line', name: 'asmpp_aggreement_biz', position: 4, title: 'What is the name of the other business involved in this agreement?'
                },
                {
                    question_type: 'naics_code', name: 'asmpp_agreement_naics', position: 5, title: 'Select the NAICS code this mentor-protégé relationship was established with:'
                }
              ]
            end
          end
          question_section 'asmpp_agreement', 3, title: 'MPP Agreement', submit_text: 'Save and continue' do
            null_with_attachment_required 'mpp_agreement', 0, title: 'Upload your written ASMPP Mentor-Protégé Agreement (13 CFR 125.9) for which you are applying to this program, signed and dated by both the mentor and the protégé.'
          end
          question_section 'asmpp_protege_needs', 4, title: 'Protégé Needs', submit_text: 'Save and continue' do
            question_section 'asmpp_determine_needs', 0, title: 'Determine Needs', submit_text: 'Save and continue' do
              yesno 'mpp_providing_mgmt_and_tech', 0, title: 'Will your mentor be providing your firm with management and technical assistance?'
              yesno 'mpp_providing_financial', 1, title: 'Will your mentor be providing your firm with financial assistance?'
              yesno 'mpp_providing_contracting', 2, title: 'Will your mentor be providing your firm with contracting assistance?'
              yesno 'mpp_providing_trade_ed', 3, title: 'Will your mentor be providing your firm with international trade education assistance?'
              yesno 'mpp_providing_biz_dev', 4, title: 'Will your mentor be providing your firm with business development assistance?'
              yesno 'mpp_providing_gen_admin', 5, title: 'Will your mentor be providing your firm with general and/or administrative assistance?'
            end
            question_section 'asmpp_management_tech', 1, title: 'Management/Technical', defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'mandt_needs', 0, title: "What are your firm's management and technical needs?"
              text_field_multiline 'mandt_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'mandt_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'mandt_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
            question_section 'asmpp_financial', 2, title: 'Financial', defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'financial_needs', 0, title: "What are your firm's financial needs?"
              text_field_multiline 'financial_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'financial_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'financial_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
            question_section 'asmpp_contracting', 3, title: 'Contracting', defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'contracting_needs', 0, title: "What are your firm's contracting needs?"
              text_field_multiline 'contracting_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'contracting_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'contracting_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
            question_section 'asmpp_intl_trade_ed', 4, title: "Int'l Trade Education", defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'ed_needs', 0, title: "What are your firm's international trade education needs?"
              text_field_multiline 'ed_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'ed_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'ed_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
            question_section 'asmpp_biz_dev', 5, title: 'Business Development', defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'bd_needs', 0, title: "What are your firm's business development needs?"
              text_field_multiline 'bd_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'bd_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'bd_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
            question_section 'asmpp_general_admin', 6, title: 'General/Administrative', defer_applicability_for: 'asmpp_determine_needs', submit_text: 'Save and continue' do
              text_field_multiline 'ga_needs', 0, title: "What are your firm's general and/or administrative needs?"
              text_field_multiline 'ga_activities', 1, title: 'What activities will your mentor be doing, within your mentor-protégé relationship, to support these needs?'
              text_field_multiline 'ga_timeline', 2, title: 'What are your timeline details and number of hours in annual increments for accomplishing these needs within the mentor-protégé relationship?'
              text_field_multiline 'ga_success', 3, title: 'How will you measure success for accomplishing these needs within the mentor-protégé relationship?'
            end
          end
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
      end
    end

    asmpp_protege.create_rules! do
      section_rule 'asmpp_training', 'protege_general_biz'
      section_rule 'protege_general_biz', 'asmpp_protege_active_agreements', {
          klass: 'Answer', identifier: 'asmpp_other_active_agreements', value: 'yes'
      }
      section_rule 'protege_general_biz', 'asmpp_agreement', {
          klass: 'Answer', identifier: 'asmpp_other_active_agreements', value: 'no'
      }
      section_rule 'asmpp_protege_active_agreements', 'asmpp_agreement'
      section_rule 'asmpp_agreement', 'asmpp_determine_needs'
      section_rule 'asmpp_determine_needs', 'review', klass: 'MultiPath', rules: [
        {
          'asmpp_management_tech': {
              klass: 'Answer',
              identifier: 'mpp_providing_mgmt_and_tech',
              value: 'yes'
          }
        },
        {
          'asmpp_financial': {
              klass: 'Answer',
              identifier: 'mpp_providing_financial',
              value: 'yes'
          }
        },
        {
          'asmpp_contracting': {
              klass: 'Answer',
              identifier: 'mpp_providing_contracting',
              value: 'yes'
          }
        },
        {
          'asmpp_intl_trade_ed': {
              klass: 'Answer',
              identifier: 'mpp_providing_trade_ed',
              value: 'yes'
          }
        },
        {
          'asmpp_biz_dev': {
              klass: 'Answer',
              identifier: 'mpp_providing_biz_dev',
              value: 'yes'
          }
        },
        {
          'asmpp_general_admin': {
              klass: 'Answer',
              identifier: 'mpp_providing_gen_admin',
              value: 'yes'
          }
        }
      ]
    end

    asmpp_mentor = Questionnaire::SubQuestionnaire.create! name: 'asmpp_mentor', title: 'Mentor Information', anonymous: false, program: Program.get('asmpp'), review_page_display_title: 'Mentor Information'
    asmpp_mentor.create_sections! do
      root 'asmpp_mentor_root', 1, title: 'Mentor Information' do
        question_section 'asmpp_mentor', 1, title: 'Mentor Information' do
          question_section 'asmpp_mentor_training', 1, title: 'Training', submit_text: 'Save and continue', first: true do
            null_with_attachment_required 'asmpp_completion_cert', 0, title: 'Complete the online <a href="https://www.sba.gov/course/all-small-mentor-protege-program/" target="_blank" class="usa-external_link">All Small Mentor-Protégé Program training</a> and upload your certificate of completion.'
          end
          question_section 'asmpp_mentor_business_info', 2, title: 'Business Info', submit_text: 'Save and continue' do
            duns 'asmpp_duns', 0, title: 'Enter your DUNS number:'
            full_address 'asmpp_firm_address', 1, title: 'Enter your firm’s address:'
            text_field_single_line 'asmpp_phone_number', 2, title: "Enter your firm’s phone number:"
            text_field_single_line 'asmpp_email_address', 3, title: "Enter your email address:"
            yesno 'asmpp_other_active_agreements', 4, title: 'Do you have any active Mentor-Protégé Agreements with the SBA or another federal government agency, either as a protégé or a mentor to another firm?'
            repeating_question_section 'asmpp_mentor_active_agreements', 5, title: 'Active Agreements', submit_text: 'Save and continue' do
              repeating_question 'asmpp_mentor_active_agreements', 0, title: '', multi: true, repeater_label: 'Agreement', sub_questions: [
                {
                    question_type: 'picklist', name: 'asmpp_agreement_role', position: 1, title: "What is your firm’s role in this agreement?", possible_values: %w(Mentor Protégé)
                },
                {
                    question_type: 'picklist', name: 'asmpp_agreement_agency', position: 2, title: 'Which agency sent the approval letter?', possible_values: ['Department of Defense', 'Department of Energy', 'Department of Homeland Security', 'Department of Transportation', 'Department of the Treasury', 'Department of Veterans Affairs', 'General Services Administration', 'National Aeronautics and Space Administration', 'Small Business Administration', 'U.S. Agency for International Development', 'Other']
                },
                {
                    question_type: 'date', name: 'asmpp_agreement_date', position: 3, title: 'What is the determination date stated in the letter?'
                },
                {
                    question_type: 'text_field_single_line', name: 'asmpp_aggreement_biz', position: 4, title: 'What is the name of the other business involved in this agreement?'
                },
                {
                    question_type: 'naics_code', name: 'asmpp_agreement_naics', position: 5, title: 'Select the NAICS code this mentor-protégé relationship was established with:'
                }
              ]
            end
          end
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
      end
    end
    asmpp_mentor.create_rules! do
      section_rule 'asmpp_mentor_training', 'asmpp_mentor_business_info'
      section_rule 'asmpp_mentor_business_info', 'asmpp_mentor_active_agreements',{
          klass: 'Answer', identifier: 'asmpp_other_active_agreements', value: 'yes'
      }
      section_rule 'asmpp_mentor_business_info', 'review',{
          klass: 'Answer', identifier: 'asmpp_other_active_agreements', value: 'no'
      }
      section_rule 'asmpp_mentor_active_agreements', 'review'
    end

    q1 = Question.find_by(name: 'asmpp_completion_cert')
    doc_type1 = DocumentType.find_by(name: 'Mentor-Protégé Program Training Certificate')
    DocumentTypeQuestion.create(question_id: q1.id, document_type_id: doc_type1.id) if doc_type1 && q1

    q1 = Question.find_by(name: 'asmpp_other_active_agreements')
    doc_type1 = DocumentType.find_by(name: 'Mentor-Protégé Agreement')
    DocumentTypeQuestion.create(question_id: q1.id, document_type_id: doc_type1.id) if doc_type1 && q1
    doc_type2 = DocumentType.create! name: "MPA Approval Letter"
    DocumentTypeQuestion.create(question_id: q1.id, document_type_id: doc_type2.id) if doc_type2 && q1

    asmpp = Questionnaire::ASMPPInitial.create! name: 'asmpp_initial', title: 'ASMPP Initial Application', anonymous: false, program: Program.get('asmpp'), certificate_type: cert_type, review_page_display_title: 'ASMPP Initial Program Certification Summary', link_label: 'ASMPP Application', human_name: 'ASMPP'
    asmpp.create_sections! do
      root 'asmpp_root', 1, title: 'ASMPP Master Application' do
        master_application_section 'asmpp_master', 1, title: 'ASMPP Initial Program', first: true do
          sub_questionnaire 'asmpp_eligibility', 1, title: 'Basic Eligibility', submit_text: 'Save and continue', status: Section::NOT_STARTED, prescreening: true
          sub_questionnaire 'asmpp_protege', 2, title: 'Protégé Information', submit_text: 'Save and continue', status: Section::NOT_STARTED
          sub_questionnaire 'asmpp_mentor', 3, title: 'Mentor Information', submit_text: 'Save and continue', status: Section::NOT_STARTED
          adhoc_questionnaires_section 'adhoc_questions', title: 'Adhoc Questions', position: 10, submit_text: 'Save and continue'
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
      end
    end
    asmpp.create_rules! do
      section_rule 'asmpp_master', 'asmpp_eligibility'
      section_rule 'asmpp_eligibility', 'asmpp_protege'
      section_rule 'asmpp_protege', 'asmpp_mentor'
      section_rule 'asmpp_mentor', 'review'
      section_rule 'review', 'signature'
    end

    section = Section.find_by(questionnaire_id: Questionnaire.get('asmpp_initial').id, name: 'signature')
    ActiveRecord::Base.connection.execute("UPDATE sections SET is_last = 't' WHERE id = #{section.id};")

    ActiveRecord::Base.connection.execute("UPDATE sections SET is_last = 't' WHERE id = #{Section.find_by(questionnaire_id: asmpp_eligibility.id, name: 'review').id};")
    ActiveRecord::Base.connection.execute("UPDATE sections SET is_last = 't' WHERE id = #{Section.find_by(questionnaire_id: asmpp_protege.id, name: 'review').id};")
    ActiveRecord::Base.connection.execute("UPDATE sections SET is_last = 't' WHERE id = #{Section.find_by(questionnaire_id: asmpp_mentor.id, name: 'review').id};")

    cert_type.current_questionnaires.create!(kind: 'initial', questionnaire: asmpp)

    Program.find_by(name: 'asmpp').update_attribute :title, 'All Small Mentor-Protégé Program'
    CertificateType::ASMPP.find_by(name: 'asmpp').update_attribute :title, 'ASMPP Initial Program'
  end
end