class LoadAmIEligible2Questions < ActiveRecord::Migration
  def change
    
    aie2 = Questionnaire.create! name: 'am_i_eligible_v2', title: 'Am I Eligible v2', anonymous: true


    aie2.create_sections! do
      root 'am_i_eligible_v2', 1, title: 'Am I Eligible v2', first: true do
        yesno 'us_citizen', 1,
              question_override_title: 'Are the qualifying individual(s) of the firm who are applying for SBA small business programs U.S. citizens?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the qualifying individual(s) of the firm who are applying for SBA small business programs are U.S. citizens.',
                  failure: '<b>No</b>, the qualifying individual(s) of the firm who are applying for SBA small business programs are not U.S.citizens.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, the qualifying individual(s) of the firm must be U.S. citizens.',
                  special_message: true
              }

        yesno 'unconditional_direct_51_percent', 2,
              title: 'Is the 51% ownership of the firm unconditional and direct?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the 51% ownership of the firm is unconditional and direct.',
                  failure: '<b>No</b>, the 51% ownership of the firm is not unconditional and direct.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, the owner or owners of the firm must be unconditional and direct.',
                  special_message: true
              }

        yesno 'for_profit', 3,
              title: 'Is the firm organized for profit?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the firm is organized for profit.',
                  failure: '<b>No</b>, the firm is not organized for profit.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, firms must be for profit.',
                  special_message: true
              }

        yesno 'non_suspended', 4,
              title: 'Do you affirm that neither this firm, nor any of its owners, have ever been debarred or suspended by any federal entity?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, I affirm that neither this firm, nor any of its owners, have ever been debarred or suspended by any federal entity.',
                  failure: '<b>No</b>, I do not affirm that neither this firm, nor any of its owners, have ever been debarred or suspended by anyfederal entity.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, the owner(s) of the firm must not have been debarred or suspended by a federal entity.',
                  special_message: true
              }

        yesno 'us_business', 5,
              title: 'Does the firm have a place of business in the U.S. and operate primarily within the United States, or makes a significant contribution to the U.S. economy through payment of taxes or use of American products, materials or labors?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the firm has a place of business in the U.S. and operates primarily within the United States, or makes a significant contribution to the U.S. economy through payment of taxes or use of American products, materials or labors.',
                  failure: '<b>No</b>, the firm does not have a place of business in the U.S. and operate primarily within the United States, or makes a significant contribution to the U.S. economy through payment of taxes or use of American products, materials or labors.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, the firm must have a place of business in the U.S. or make a significant contribution to the U.S. economy.',
                  special_message: true
              }

        yesno 'small_naics', 6,
              title: 'Is the firm considered small in accordance with its primary North American Industry Classification System (NAICS) code?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the firm is considered small in accordance with its primary North American Industry Classification System (NAICS) code.',
                  failure: '<b>No</b>, the firm is not considered small in accordance with its primary North American Industry Classification System (NAICS) code.',
                  requirements: ['wosb', 'edwosb', 'hubzone', 'eighta'],
                  reason: 'In order to participate in SBA small business programs, the firm must be designated as small in accordance with its primary NAICS code.',
                  special_message: true
              }

        yesno 'women_owning_business', 7,
              question_override_title: 'Are the qualifying individual(s) of the firm <u>women</u> who own at least 51% of the firm?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the qualifying individual(s) of the firm are <i>women</i> who own at least 51% of the firm.',
                  failure: '<b>No</b>, the qualifying individual(s) of the firm are not <i>women</i> who own at least 51% of the firm.',
                  requirements: ['wosb', 'edwosb'],
                  reason: 'To certify as a WOSB or EDWOSB the firm must be owned by women.'
              }

        yesno 'naics_fed_set_asides', 8,
              title: 'Are WOSB Federal Contract Program set-asides available in your primary NAICS code?',
              helpful_info: {
                  type: 'naics_code',
                  expected: true,
                  success: '<b>Yes</b>, the WOSB Federal Contract Program set-asides are available in your primary NAICS code.',
                  failure: '<b>No</b>, the WOSB Federal Contract Program set-asides are not available in your primary NAICS code.',
                  requirements: ['wosb', 'edwosb'],
                  reason: 'The NAICS code entered does not appear on the list of designated industries in which WOSB Program set-asides are authorized. As such, be advised that federal contracts currently cannot be set-aside under the WOSB Program in this industry. However, this does not preclude you from certifying as a WOSB or EDWOSB if you meet the requirements of the WOSB Program.'
              }

        yesno 'economically_disadvantaged_wosb', 9,
              title: 'Are the qualifying individual(s) economically disadvantaged women under the guidelines of the Women-Owned Small Business (WOSB) Program?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the qualifying individual(s) are economically disadvantaged <i>women</i> under the guidelines of the Women-Owned Small Business (WOSB) Program.',
                  failure: '<b>No</b>, the qualifying individual(s) are not economically disadvantaged <i>women</i> under the guidelines of the Women-Owned Small Business (WOSB) Program.',
                  requirements: ['edwosb'],
                  reason: 'To qualify for EDWOSB the firm must be economically disadvantaged.'
              }

        yesno 'economically_disadvantaged_8a', 10,
              title: 'Are the individual(s) interested in participating in SBA small business programs economically disadvantaged under 8(a) BD Program guidelines?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the individual(s) interested in participating in SBA small business programs are economically disadvantaged under 8(a) BD Program guidelines.',
                  failure: '<b>No</b>, the individual(s) interested in participating in SBA small business programs are not economically disadvantaged under 8(a) BD Program guidelines.',
                  requirements: ['eighta'],
                  reason: 'Qualifying individuals must meet the economically disadvantaged financial criteria to participate in the program. However, many factors are taken into consideration during application review and it is possible that you may still qualify to participate. Contact your local SBA 8(a) Business Office for more information.'
              }

        yesno 'socially_disadvantaged', 11,
              title: 'Do you identify as one of the following?<br><ul><li>Black American</li><li>Asian Pacific American</li><li>Hispanic American</li><li>Native American</li><li>Subcontinent Asian American</li></ul>',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, I do identify as one of the following.',
                  failure: '<b>No</b>, I do not identify as one of the following.',
                  requirements: ['eighta'],
                  reason: 'Qualifying individuals must meet socially disadvantaged criteria in order to participate in the program.'
              }

        yesno 'socially_disadvantaged_chronic', 12,
              title: 'Do you consider yourself socially disadvantaged because of you experienced bias of a chronic and substantial nature?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, I do consider myself socially disadvantaged because I experienced bias of a chronic and substantial nature.',
                  failure: '<b>No</b>, I do not consider myself socially disadvantaged because I experienced bias of a chronic and substantial nature.',
                  requirements: ['eighta'],
                  reason: 'Qualifying individuals must meet socially disadvantaged criteria in order to participate in the program.'
              }

        yesno 'eighta_certified', 13,
              title: 'Has the firm previously been certified as an 8(a) participant?',
              helpful_info: {
                  type: 'boolean',
                  expected: false,
                  success: '<b>Yes</b>, the firm has been previously certified as an 8(a) participant.',
                  failure: '<b>No</b>, the firm has not been previously certified as an 8(a) participant.',
                  requirements: ['eighta'],
                  reason: 'A firm and/or any qualifying individuals that have previously participated in the 8(a) BD Program are not eligible to participate again.'
              }

        yesno 'eighta_one_time_used', 14,
              title: 'Have any individual(s) claiming social and economic disadvantage previously used their one time 8(a) eligibility to qualify a business for the 8(a) BD Program?',
              helpful_info: {
                  type: 'boolean',
                  expected: false,
                  success: '<b>Yes</b>, any individual(s) claiming social and economic disadvantage have previously used their one time 8(a) eligibility to qualify a business for the 8(a) BD Program.',
                  failure: '<b>No</b>, any individual(s) claiming social and economic disadvantage have not previously used their one time 8(a) eligibility to qualify a business for the 8(a) BD Program.',
                  requirements: ['eighta'],
                  reason: 'A firm and/or any qualifying individuals that have previously participated in the 8(a) BD Program are not eligible to participate again.'
              }

        yesno 'address_in_hubzone', 15,
              title: 'Is the address of the location where the majority of the firm’s employees work located in a HUBZone?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, the firm’s business address is located in a HUBZone.',
                  failure: '<b>No</b>, the firm’s business address is  not located in a HUBZone.',
                  requirements: ['hubzone'],
                  reason: 'A firm and at least 35% of its employees must reside in a certified HUBzone.'
              }

        yesno 'employees_in_hubzone', 16,
              title: 'Do 35% or more of the firm’s employees reside in a HUBZone?',
              helpful_info: {
                  type: 'boolean',
                  expected: true,
                  success: '<b>Yes</b>, 35% or more of the firm’s employees reside in a HUBZone.',
                  failure: '<b>No</b>, 35% or more of the firm’s employees do not reside in a HUBZone.',
                  requirements: ['hubzone'],
                  reason: 'A firm and at least 35% of its employees must reside in a certified HUBzone.'
              }
      end
    end
  end
end
