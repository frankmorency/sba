require 'question_type/date'

class LoadEdwosb < ActiveRecord::Migration
  def change
    owner_list = QuestionType::OwnerList.new name: 'owner_list', title: 'Form 413 Owner List'
    owner_list.question_rules.new mandatory: false, capability: :add_attachment, condition: :always
    owner_list.save!

    yncry = QuestionType::Boolean.new name: 'yesno_with_comment_required_on_yes', title: 'Yes No with Comment Required on Yes'
    yncry.question_rules.new mandatory: true, capability: :add_comment, condition: :equal_to, value: 'yes'
    yncry.save!

    QuestionType::Address.create! name: 'address', title: 'Address'
    QuestionType::Date.create! name: 'date', title: 'Date'
    QuestionType::Percentage.create! name: 'percentage', title: 'Percentage'
    QuestionType::Currency.create! name: 'currency', title: 'Currency'
    QuestionType::Picklist.create! name: 'picklist', title: 'Picklist'

    c = QuestionType::Currency.new name: 'currency_with_comment_required_on_zero', title: 'Currency'
    c.question_rules.new mandatory: true, capability: :add_comment, condition: :equal_to, value: '0'
    c.save!

    QuestionType::RealEstate.create! name: 'real_estate', title: 'Real Estate'

    edwosb = Questionnaire.create! name: 'edwosb', title: 'EDWOSB Application', anonymous: false
    edwosb.evaluation_purposes.create! name: 'edwosb_certification', title: 'Economically Disadvantaged Women Owned Small Business', certificate_type: CertificateType.get('edwosb')
    CertificateType.get('edwosb').update_attribute(:questionnaire_id, edwosb.id)


    edwosb.create_sections! do
      template 'owners', 0, title: '{value}', displayable: false do
        template 'cash_on_hand', 0 do
          date 'edwosb_cash_as_of_date', 1, title: 'As of Date: '
          currency 'edwosb_cash_on_hand', 2, title: 'Cash on Hand'
          currency 'edwosb_savings_balance', 3, title: 'Savings Account(s) Balance'
          currency 'edwosb_checking_balance', 4, title: 'Checking Account(s) Balance'
        end
        template 'other_sources_of_income', 1 do
          currency 'edwosb_salary', 1, title: 'Salary'
          # currency_with_comment_required_on_zero 'edwosb_other_income', 2, title: 'Other Income'
          currency 'edwosb_other_income', 2, title: 'Other Income'
          currency 'edwosb_biz_equity', 3, title: 'Applicant’s Business Equity'
          currency 'edwosb_equity_in_other_firms', 4, title: 'Applicant’s Equity in Other Firms'
        end
        template 'notes_receivable', 2, title: 'Notes Receivable' do
          yesno_with_table_required_on_yes 'notes_receivable', 1, title: 'Do you have any notes receivable from others?', strategy: "NotesReceivables"
        end
        template 'retirement_accounts', 3, title: 'Retirement Accounts' do
          yesno_with_table_required_on_yes 'roth_ira', 1, title: 'Do you have a Roth IRA?', strategy: "Retirement"
          yesno_with_table_required_on_yes 'other_retirement_accounts', 2, title: 'Do you have any other retirement accounts?', strategy: "Retirement"
        end
        template 'life_insurance', 4, title: 'Life Insurance', validation_rules: {
            toggle: {
              life_insurance_loans: {
                  show_on: 'yes',
                  dependent: 'life_insurance_loan_value',
                  clear_on_hide: true
              }
            }
        } do
          yesno_with_table_required_on_yes 'life_insurance_cash_surrender', 1, title: 'Do you have a life insurance policy that has a Cash Surrender Value?', strategy: "LifeInsurance"
          yesno 'life_insurance_loans', 1, title: 'Do you have any loans against a life insurance policy?'
          currency 'life_insurance_loan_value', 2, title: 'What is the current balance of any loans against life insurance?', validation_rules: {required: false}
        end
        template 'stocks_bonds', 5, title: 'Stocks & Bonds' do
          yesno_with_table_required_on_yes 'stocks_bonds', 1, title: 'Do you have any stocks, bonds or Mutual Funds?', strategy: "StocksAndBonds"
        end
        template 'real_estate_primary', 6, title: 'Real Estate - Primary Residence', template_type: 'Section::RealEstate' do
          yesno 'has_primary_real_estate', 1, title: 'Do you own your primary residence?'
          # HACK: Positions are important here - they start at 0 so the javascript will work in real_estate_sub_question.slim
          real_estate 'primary_real_estate', 2, title: 'Primary Residence Details', multi: false, sub_questions: [
              {
                  question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your primary residence?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your primary residence jointly owned?'
              },
              {
                  question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your primary residence?'
              },
              {
                  question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 4, title: 'What percentage of the mortgage are you responsible for in your primary residence?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 5, title: 'Is your name on the mortgage?'
              },
              {
                  question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your primary residence?'
              },
              {
                  question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your primary residence?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your primary residence?'
              },
              {
                  question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 9, title: 'What is the current balance of the lien(s)?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_rent_income', position: 10, title: 'Do you receive income from your primary residence (rent, etc.)?'
              },
              {
                  question_type: 'currency', name: 'real_estate_rent_income_value', position: 11, title: 'What is the income YOU receive from your primary residence (calculated annually)?'
              }
          ]
        end
        template 'real_estate_other', 7, title: 'Real Estate - Other', template_type: 'Section::RealEstate' do
          yesno 'has_other_real_estate', 1, title: 'Do you own any additional real estate?'
          # HACK: Positions are important here - they start at 0 so the javascript will work in real_estate_sub_question.slim
          real_estate 'other_real_estate', 2, title: 'List your other real estate holdings:', multi: true, sub_questions: [
              {
                  question_type: 'picklist', name: 'real_estate_type', position: 0, title: 'What type of Other Real Estate do you own?', possible_values: ['Other Residential', 'Commercial', 'Industrial', 'Land', 'Other Real Estate']
              },
              {
                  question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your Other Real Estate?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your Other Real Estate jointly owned?'
              },
              {
                  question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your Other Real Estate?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 4, title: 'Is your name on the mortgage?'
              },
              {
                  question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 5, title: 'What percentage of the mortgage are you responsible for in your Other Real Estate?'
              },
              {
                  question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your Other Real Estate?'
              },
              {
                  question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your Other Real Estate?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?'
              },
              {
                  question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 9, title: 'What is the current balance of the lien(s)?'
              },
              {
                  question_type: 'yesno', name: 'real_estate_rent_income', position: 10, title: 'Do you receive income from your Other Real Estate (rent, etc.)?'
              },
              {
                  question_type: 'currency', name: 'real_estate_rent_income_value', position: 11, title: 'What is the income YOU receive from your Other Real Estate (calculated annually)?'
              }

          ]
        end
        template 'personal_property', 8, title: 'Personal Property' do
          yesno_with_table_required_on_yes 'automobiles', 1, title: 'Do you own any automobiles?', strategy: "PersonalProperty"
          yesno_with_table_required_on_yes 'pledged_automobiles', 2, title: 'Does any of the above listed property is pledged as security?', strategy: "PledgedPersonalProperty"
          yesno_with_comment_required_on_yes 'automobile_delinquent_liens', 3, title: 'Are any liens delinquent?'
          yesno_with_table_required_on_yes 'other_personal_property', 4, title: 'Do you own any other personal property or assets?', strategy: "PersonalProperty"
          yesno_with_table_required_on_yes 'pledged_other_property', 5, title: 'Does any of the above listed property is pledged as security?', strategy: "PledgedPersonalProperty"
          yesno_with_comment_required_on_yes 'other_delinquent_liens', 6, title: 'Are any liens delinquent?'
        end
        template 'notes_payable', 8, title: 'Notes Payable', validation_rules: {
                                     toggle: {
                                         recurring_accounts_payable: {
                                             show_on: 'yes',
                                             dependent: 'recurring_accounts_payable_amount',
                                             clear_on_hide: true
                                         }
                                     }
                                 } do
          yesno_with_table_required_on_yes 'notes_payable', 1, title: 'Do you have any notes payable?', strategy: "NotesPayable"
          yesno 'recurring_accounts_payable', 2, title: 'Do you have any other Accounts Payable for products and services purchased on credit or on a regular payment basis?'
          currency 'recurring_accounts_payable_amount', 3, title: 'Enter total amount here', validation_rules: {required: false}

        end

        template 'assessed_taxes', 9, title: 'Assessed Taxes' do
          yesno_with_table_required_on_yes 'assessed_taxes', 1, title: 'Do you have any Assessed Taxes that were unpaid?', strategy: 'AssessedTaxes'
          yesno_with_table_required_on_yes 'other_liabilities', 2, title: 'Do you have any other liabilities?', strategy: 'OtherLiabilities'
        end
        template 'agi', 10, title: "Adjusted Gross Income" do
          currency 'agi_year_1', 1, title: 'Adjusted Gross Income (As shown on tax returns for Most Recent tax year)'
          currency 'agi_year_2', 2, title: 'Adjusted Gross Income (As shown on tax returns for previous tax year)'
          currency 'agi_year_3', 3, title: 'Adjusted Gross Income (As shown on tax returns for year before previous tax year)'
        end
        template 'personal_summary', 11, title: 'Personal Summary', template_type: 'Section::PersonalSummary'
        template 'personal_privacy', 12, title: 'Privacy Statements', template_type: 'Section::PersonalPrivacy'
      end

      root 'edwosb_root', 1, title: 'EDWOSB Application' do
        question_section 'pc', 0, title: 'Prior Certification' do
          question_section '8a', 1, title: '8(a)', first: true do
            question '8aq1', 1, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'third_party_cert', 2, title: 'Third Party Certification' do
            question_section 'third_party_cert_part_1', 1, title: 'Third Party' do
              question 'tpc1_q1', 1, positive_response: { edwosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_2', 2, title: 'Changes in Eligibility' do
              question 'tpc2_q1', 1, positive_response: { edwosb_certification: 'yes' }
            end
            question_section 'third_party_cert_part_3', 3, title: 'Non-qualification' do
              question 'tpc3_q1', 1, positive_response: { edwosb_certification: 'yes' }
            end
          end
        end
        question_section 'business', 3, title: 'Business' do
          question_section 'corporation', 1, title: 'Corporation & S-Corp' do
            question_section 'corp1', 1, title: 'Stocks' do
              question 'corp1_q1', 1, positive_response: { edwosb_certification: 'yes' }
              question 'corp1_q2', 2, positive_response: { edwosb_certification: 'yes' }
              question 'corp1_q3', 3, positive_response: { edwosb_certification: 'yes' }
            end
            question_section 'corp2', 2, title: 'Stock Ownership' do
              question 'corp2_q1', 1, positive_response: {edwosb_certification: 'yes'}
            end
            question_section 'corp3', 3, title: 'Corporation Ownership' do
              question 'corp3_q1', positive_response: {edwosb_certification: 'yes'}
            end
            question_section 'corp4', 4, title: 'Women Ownership' do
              question 'corp4_q1', positive_response: {edwosb_certification: 'yes'}
            end
            question_section 'corp5', 5, title: 'Ownership & Control' do
              question 'corp5_q1', positive_response: {edwosb_certification: 'yes'}
            end
          end
          question_section 'partnership', 2, title: 'Partnership' do
            question 'partn_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'partn_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'llc', 3, title: 'LLC' do
            question 'llc_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'llc_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
        end
        question_section 'operations', 4, title: 'Operations' do
          question_section 'operations_part_1', 1, title: 'Citizenship & Ownership' do
            question 'oper1_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper1_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'operations_part_2', 2, title: 'Businesses & Trusts' do
            question 'oper2_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper2_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'operations_part_3', 3, title: 'Operations & Management' do
            question 'oper3_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper3_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'operations_part_4', 4, title: 'Expertise & Employment' do
            question 'oper4_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper4_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'operations_part_5', 5, title: 'Highest Officer & Control' do
            question 'oper5_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper5_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'operations_part_6', 6, title: 'SBA Exam & Daily Operations' do
            question 'oper6_q1', 1, positive_response: { edwosb_certification: 'yes' }
            question 'oper6_q2', 2, positive_response: { edwosb_certification: 'yes' }
          end
        end

        question_section 'edwosb_section', 5, title: 'EDWOSB Group' do
          question_section 'edwosb_section_1', 0, title: 'Net Worth' do
            yesno 'demonstrate_less_than_750k', 1, title: 'The economically disadvantaged woman upon whom eligibility is based has read the SBA\'s regulations defining economic disadvantage and can demonstrate that her personal net worth is less than $750,000, excluding her ownership interest in the concern and her equity interest in her primary personal residence', positive_response: { edwosb_certification: 'yes' }
            yesno 'woman_financial_condition', 2, title: 'The personal financial condition of the woman claiming economic disadvantage, including her personal income for the past three years (including bonuses, and the value of company stock given in lieu of cash), her personal net worth and the fair market value of all of her assets, whether encumbered or not, evidences that she is economically disadvantaged.', positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'edwosb_section_2', 1, title: 'Adjusted Gross Income' do
            yesno 'agi_3_year_less_than_350k', 1, title: 'The adjusted gross income of the woman claiming economic disadvantage averaged over the three years preceding the certification does not exceed $350,000', positive_response: { edwosb_certification: 'yes' }
            yesnona_with_comment_required 'agi_3_year_exceeds_but_uncommon', 2, title: 'The adjusted gross income of the woman claiming economic disadvantage averaged over the three years preceding the certification exceeds $350,000; however, the woman can show that this income level was unusual and not likely to occur in the future, that losses commensurate with and directly related to the earnings were suffered, or that the income is not indicative of lack of economic disadvantage', positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'edwosb_section_3', 2, title: 'Fair Market Value' do
            yesno 'woman_assets_less_than_6m', 1, title: 'The fair market value of all the assets (including her primary residence and the value of the business concern but excluding funds invested in an Individual Retirement Account or other official retirement account that are unavailable until retirement age without a significant penalty) of the woman claiming economic disadvantage does not exceed $6 million.', positive_response: { edwosb_certification: 'yes' }
          end
          question_section 'edwosb_section_4', 3, title: 'Assets' do
            yesno 'woman_has_not_transferred_assets', 1, title: 'The woman claiming economic disadvantage has not transferred any assets within two years of the date of the certification.', positive_response: { edwosb_certification: 'yes' }
            yesnona_with_comment_required 'woman_asset_transfer_excusable', 2, title: 'The woman claiming economic disadvantage has transferred assets within two years of the date of the certification. However, the transferred assets were: (1) to or on behalf of an immediate family member for that individual\'s education, medical expenses, or some other form of essential support; or (2) to an immediate family member in recognition of a special occasion, such as a birthday, graduation, anniversary, or retirement.', positive_response: { edwosb_certification: 'yes' }
          end
        end

        spawner 'form413', 6, title: 'Financial Data', template_name: 'owners', repeat: { name: '{value}', model: 'BusinessPartner', starting_position: 1, next_section: 'review' } do
          owner_list 'owners', 1, title: 'Personal Information', decider: true, helpful_info: nil
          yesno_with_attachment_required_on_yes 'owner_divorced', 2, title: 'Is anyone listed above divorced? If yes, please provide separation documents'
        end

        review_section 'review', 100, title: 'Review', submit_text: "Accept"
        signature_section 'signature', 101, title: 'Signature'
      end
    end

    edwosb.create_rules! do
      template_rules 'owners' do
        section_rule nil, 'cash_on_hand'
        section_rule 'cash_on_hand', 'other_sources_of_income'
        section_rule 'other_sources_of_income', 'notes_receivable'
        section_rule 'notes_receivable', 'retirement_accounts'
        section_rule 'retirement_accounts', 'life_insurance'
        section_rule 'life_insurance', 'stocks_bonds'
        section_rule 'stocks_bonds', 'real_estate_primary'
        section_rule 'real_estate_primary', 'real_estate_other'
        section_rule 'real_estate_other', 'personal_property'
        section_rule 'personal_property', 'notes_payable'
        section_rule 'notes_payable', 'assessed_taxes'
        section_rule 'assessed_taxes', 'agi'
        section_rule 'agi', 'personal_summary'
        section_rule 'personal_summary', 'personal_privacy'
        section_rule 'personal_privacy', nil
      end

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
      section_rule 'operations_part_6', 'edwosb_section_1'
      section_rule 'edwosb_section_1', 'edwosb_section_2'
      section_rule 'edwosb_section_2', 'edwosb_section_3'
      section_rule 'edwosb_section_3', 'edwosb_section_4'
      section_rule 'edwosb_section_4', 'form413'
      section_rule 'form413', 'review'
      section_rule 'review', 'signature'
    end
  end
end
