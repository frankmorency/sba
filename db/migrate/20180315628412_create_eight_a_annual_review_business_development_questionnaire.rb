class CreateEightAAnnualReviewBusinessDevelopmentQuestionnaire < ActiveRecord::Migration
  def change
    Questionnaire.transaction do
      eight_a_business_development_annual = Questionnaire::SubQuestionnaire.create! name: 'eight_a_annual_business_development', title: 'Business Development', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Ownership Summary'

      eight_a_business_development_annual.create_sections! do
        root 'eight_a_business_development_annual_root', 1, title: 'Business Development' do
          question_section 'eight_a_annual_business_development', 1, title: 'Business Development', submit_text: 'Save and continue' do
            
            question_section 'eight_a_annual_mentor_protege', 0, title: '8(a) Mentor-Protégé Program', submit_text: 'Save and continue', first: true do
              yesno_with_attachment_required_on_yes 'eight_a_annual_mentor_protege_program', 0, title: 'Is your firm in the 8(a) Mentor-Protégé program?'
            end
            
            question_section 'eight_a_annual_business_plan', 1, title: 'Business Plan' do
              question_section 'eight_a_annual_business_plan_upload', 0, title: 'Upload Business Plan', submit_text: 'Save and continue' do
                null_with_attachment_required 'eight_a_annual_business_plan_upload', 0, title: "Please upload your firm's current business plan as a PDF."
                yesno 'eight_a_annual_business_plan_changed', 1, title: 'Have you changed or updated your business plan?'
              end
              
              question_section 'eight_a_annual_business_plan_updates', 1, title: 'Updates to Business Plan', submit_text: 'Save and continue' do
                checkboxes_with_comment_required_on_last_selection 'eight_a_annual_business_plan_update_sections', 0, title: "Which sections of the business plan have you changed or updated?",
                                              possible_values: ['Business History, Background, and Objectives', 'Business Environment', 'Products and/or Services',
                                                                'Present Market', 'Competition', 'Marketing Plan', 'Management and Organization', 'Business Resources',
                                                                'Financial Plan/Data', 'Contract Support Targets', 'Other']
              end
            end
            
            question_section 'eight_a_annual_stage_program', 2, title: 'Stage of the Program' do
              question_section 'eight_a_annual_stage_program_determination', 0, title: 'Determine Stage of the Program', submit_text: 'Save and continue' do
                date 'eight_a_annual_stage_program_date', 0, title: "When did your firm enter the 8(a) Program?"
                yesno 'eight_a_annual_stage_program_transition', 1, title: 'Is your firm in the Transitional Stage (Program Years 5 through 9)?'
              end
            
              question_section 'eight_a_annual_targets', 1, title: 'Business Activity Targets', submit_text: 'Save and continue' do
                text_field_multiline 'eight_a_annual_targets_plan', 0, title: "While your firm is in the transitional stage of the 8(a) program (years 5 through 9), how do you plan to meet the required non-8(a) business activity targets?"
              end
              
              question_section 'eight_a_annual_growth', 2, title: 'Steps for Growth', submit_text: 'Save and continue' do
                text_field_multiline 'eight_a_annual_growth_plan', 0, title: "What steps do you plan to take to ensure business growth and profitable operations after you graduate from the 8(a) program?"
              end
            end
            
            question_section 'eight_a_annual_marketing_capability', 3, title: 'Marketing Capability Statement', submit_text: 'Save and continue' do
              null_with_attachment_required 'eight_a_annual_marketing_capability_upload', 0, title: "Please upload your most recent marketing capability statement as a PDF."
              yesno_with_comment_required_on_yes 'eight_a_annual_marketing_capability_changed', 1, title: 'In the past program year, have you changed or updated this marketing capability statement?'
            end
            
            question_section 'eight_a_annual_joint_ventures', 4, title: 'Joint Ventures' do 
              question_section 'eight_a_annual_joint_ventures_determination', 0, title: 'Your 8(a) Joint Ventures', submit_text: 'Save and continue' do 
                yesno 'eight_a_annual_joint_ventures_exist', 0, title: 'Does your firm have any active 8(a) Joint Ventures?'
              end
              
              repeating_question_section 'eight_a_annual_joint_ventures_info', 1, title: 'Joint Venture Information', submit_text: 'Save and continue' do 
                repeating_question 'provide_info_on_your_joint_ventures_info', 0, title: 'Please list all your active 8(a) joint ventures.', multi: true, repeater_label: 'Joint Venture', sub_questions: [
                    {
                        question_type: 'text_field_single_line', name: 'joint_venture_name', position: 0, title: 'Joint Venture Name'
                    },
                    {
                        question_type: 'text_field_single_line', name: 'joint_venture_duns_number', position: 1, title: 'Joint Venture DUNS Number'
                    },
                    {
                        question_type: 'text_field_single_line', name: 'joint_venture_partners', position: 2, title: 'Joint Venture Partners'
                    },
                    {
                        question_type: 'picklist_with_radio_buttons', name: 'joint_venture_official_mentor', position: 3, title: 'Is this joint venture with your official 8(a) mentor?', possible_values: ['Yes', 'No', 'I don’t have an 8(a) mentor']
                    }
                ]
              end
            end

            question_section 'eight_a_annual_business_contracts', 5, title: 'Contracts', submit_text: 'Save and continue' do
              yesno_with_attachment_required_on_yes 'eight_a_annual_business_contracts_past_year', 0, title: 'Has your firm performed work on any 8(a) contracts during the past program year?'
            end

            composite_question_section 'eight_a_annual_contract_forecast', 6, title: 'Contract Forecast', submit_text: 'Save and continue' do 
              composite_question 'eight_a_annual_contract_forecast_response', 0, title: 'Each program year, you must forecast how much revenue your firm needs from 8(a) and non-8(a) contracts and subcontracts for the next program year.', title_wrapper_tag: 'p', sub_questions: [
                  {
                      question_type: 'currency', name: 'annual_eight_a_contract_forecast_sole_source', position: 1, title: 'Expected revenue from 8(a) <b>sole source</b> contracts', header: 'First forecast your 8(a) contracts for the next program year:', title_wrapper_tag: 'p'
                  },
                  {
                      question_type: 'currency', name: 'annual_eight_a_contract_forecast_competitive', position: 2, title: 'Expected revenue from 8(a) <b>competitive</b> contracts', title_wrapper_tag: 'p'
                  },
                  {
                      question_type: 'currency', name: 'annual_non_eight_a_contract_forecast_sole_source', position: 3, title: 'Expected revenue from non-8(a) <b>sole source</b> contracts', header: 'Now forecast your non-8(a) contracts for the next program year:', title_wrapper_tag: 'p'
                  },
                  {
                      question_type: 'currency', name: 'annual_non_eight_a_contract_forecast_competitive', position: 4, title: 'Expected revenue from non-8(a) <b>competitive</b> contracts', title_wrapper_tag: 'p'
                  }
              ]
            end
            
          end
          review_section 'review', 1, title: 'Review', submit_text: 'Submit'
        end
        Section.where(questionnaire_id: eight_a_business_development_annual.id, name: 'review').update_all is_last: true
      end
      
      # Creating business rules
      eight_a_business_development_annual.create_rules! do
        section_rule 'eight_a_annual_mentor_protege', 'eight_a_annual_business_plan_upload'
        section_rule 'eight_a_annual_business_plan_upload', 'eight_a_annual_business_plan_updates', {
            klass: 'Answer', identifier: 'eight_a_annual_business_plan_changed', value: 'yes'
        }
        section_rule 'eight_a_annual_business_plan_updates', 'eight_a_annual_stage_program_determination', {
            klass: 'Answer', identifier: 'eight_a_annual_business_plan_changed', value: 'yes'
        }
        section_rule 'eight_a_annual_business_plan_upload', 'eight_a_annual_stage_program_determination', {
            klass: 'Answer', identifier: 'eight_a_annual_business_plan_changed', value: 'no'
        }
        section_rule 'eight_a_annual_stage_program_determination', 'eight_a_annual_targets', {
            klass: 'Answer', identifier: 'eight_a_annual_stage_program_transition', value: 'yes'
        }
        section_rule 'eight_a_annual_targets', 'eight_a_annual_growth', {
            klass: 'Answer', identifier: 'eight_a_annual_stage_program_transition', value: 'yes'
        }
        section_rule 'eight_a_annual_growth', 'eight_a_annual_marketing_capability', {
            klass: 'Answer', identifier: 'eight_a_annual_stage_program_transition', value: 'yes'
        }
        section_rule 'eight_a_annual_stage_program_determination', 'eight_a_annual_marketing_capability', {
            klass: 'Answer', identifier: 'eight_a_annual_stage_program_transition', value: 'no'
        }
        section_rule 'eight_a_annual_marketing_capability', 'eight_a_annual_joint_ventures_determination'
        section_rule 'eight_a_annual_joint_ventures_determination', 'eight_a_annual_joint_ventures_info', {
            klass: 'Answer', identifier: 'eight_a_annual_joint_ventures_exist', value: 'yes'
        }
        section_rule 'eight_a_annual_joint_ventures_info', 'eight_a_annual_business_contracts', {
            klass: 'Answer', identifier: 'eight_a_annual_joint_ventures_exist', value: 'yes'
        }
        section_rule 'eight_a_annual_joint_ventures_determination', 'eight_a_annual_business_contracts', {
            klass: 'Answer', identifier: 'eight_a_annual_joint_ventures_exist', value: 'no'
        }
        section_rule 'eight_a_annual_business_contracts', 'eight_a_annual_contract_forecast'
        section_rule 'eight_a_annual_contract_forecast', 'review'
      end

      # Creating the new document types
      
    end
    
  end
end