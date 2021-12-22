class LoadAmIEligible < ActiveRecord::Migration
  def change
    am_i_eligible = Questionnaire.create! name: 'am_i_eligible', title: 'Am I Eligible?', anonymous: true, determine_eligibility: true

    am_i_eligible.evaluation_purposes.create! name: 'am_i_eligible_for_wosb', title: 'Women-Owned Small Business', certificate_type: CertificateType.get('wosb')
    am_i_eligible.evaluation_purposes.create! name: 'am_i_eligible_for_edwosb', title: 'Economically Disadvantaged Women-Owned Small Business', certificate_type: CertificateType.get('edwosb')

    am_i_eligible.create_sections! do
      question_section 'am_i_eligible', 1, title: 'Am I Eligible?', submit_text: 'Check Eligibility' do

        yesno 'us_citizen', 1, title: 'Are you a US Citizen?',
              positive_response: {
                  am_i_eligible_for_wosb: 'yes', am_i_eligible_for_edwosb: 'yes'
              },
              helpful_info: {
                  failure: 'You indicated that you are not a US citizen'
              },
              tooltip: 'Enter if you are a US citizen'

        yesno 'women_owning_business', 2, title: 'Do you and/or other women own and control at least 51% of the business?',
              positive_response: {
                  am_i_eligible_for_wosb: 'yes', am_i_eligible_for_edwosb: 'yes'
              },
              helpful_info: {
                   failure: 'You indicated that you and/or other women do not own at least 51% of business'
              },
              tooltip: ''

        naics_code 'naic_code', 3, title: 'Enter the NAICS Code in which your business operates',
              positive_response: {
                  am_i_eligible_for_wosb: {
                      lookup: {
                          table_name: 'eligible_naic_code', filter_column_name: 'certificate_type_name', filter_value: 'wosb', target_column: 'naic_code'
                      }
                  },
                  am_i_eligible_for_edwosb: {
                      lookup: {
                          table_name: 'eligible_naic_code', filter_column_name: 'certificate_type_name', filter_value: 'edwosb', target_column: 'naic_code'
                      }
                  }
              },
              helpful_info: {
                  failure: 'The NAICS Code you entered is not eligible for this program, other programs might be applicable',
                  maybe: 'The NAICS code entered does not appear on the list of designated industries in which WOSB Program set-asides are authorized. As such, be advised that federal contracts currently cannot be set-aside under the WOSB Program in this industry. However, this does not preclude you from certifying as a WOSB or EDWOSB if you meet the requirements of the WOSB Program.'
              },
              tooltip: 'tool tip'


        yesno 'economically_disadvantaged', 4, title: 'Are you economically disadvantaged?',
              positive_response: {
                  am_i_eligible_for_edwosb: 'yes'
              },
              helpful_info: {
                  failure: 'You indicated that you are not considered economically disadvantaged',
                  maybe: 'Your NAICS is currently not applicable for EDWOSB contract set-asides'
              },
              tooltip: 'Enter if you are economically disadvantaged'
      end
    end
  end
end
