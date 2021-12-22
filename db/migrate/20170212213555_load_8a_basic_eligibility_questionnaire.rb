class Load8aBasicEligibilityQuestionnaire < ActiveRecord::Migration
  def change
=begin
    Questionnaire.transaction do

      eight_a_eligibility = Questionnaire::SubQuestionnaire.create! name: 'eight_a_eligibility', title: '8(a) Basic Eligibility', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(A) Eligibility Summary'

      eight_a_eligibility.create_sections! do
        root 'eight_a_eligibility', 1, title: 'Basic Eligibility' do
          question_section 'eight_a_basic_eligibility_header', 0, title: 'Eligibility' do
            question_section 'eight_a_basic_eligibility_screen', 1, title: 'General Assessment', submit_text: 'Save and continue', first: true  do
              yesno 'for_profit', 0, question_override_title: 'Is the applicant firm a for-profit business?', disqualifier: {value: 'no', message: 'To qualify for the 8(a) Business Development Program, the applicant firm must be organized as for-profit business.'}
              yesno 'is_broker', 1, title: 'Is the applicant firm operating as a broker?', disqualifier: {value: 'yes', message: 'In order to participate in 8(a) Business Development Program, the applicant firm must not be a broker. Please email 8aBD@sba.gov for assistance if you are unsure about your status as a broker. Include your firm name, DUNS number and address in the email.'}
              yesnona 'generate_revenue', 2, title: 'Has the firm generated any revenue?', disqualifier: {value: 'no', message: 'In order to participate in 8(a) Business Development Program, the applicant firm must demonstrate potential for success by showing that it has been in business in its primary industry for two years, or you will need to request a waiver of this requirement. If the business concern has not yet generated revenues, you will not be successful in obtaining a waiver. Please note this is not applicable to entity-owned firms. Please email 8aBD@sba.gov for assistance if you are unsure about the firm’s revenue status. Include your firm name, DUNS number and address in the email.'}
              yesno 'disadvantaged_citizens', 3, title: 'Are all of the individual(s) claiming disadvantaged status in the applicant firm U.S. citizens?', disqualifier: {value: 'no', message: 'In order to participate in 8(a) Business Development Program, the individual(s) claiming disadvantaged status must be a U.S. citizen.'}
              yesnona_with_comment_required_on_yes 'have_dba', 4, title: 'Does the applicant firm have a Doing Business As (DBA) Name?'
            end
            question_section 'eight_a_basic_eligibility_involvement', 2, title: 'Prior 8(a) Involvement', submit_text: 'Save and continue' do
              yesno 'eighta_certified', 0, question_override_title: 'Was the applicant firm ever a certified 8(a) Business Development Program Participant?', disqualifier: {value: 'yes', message: 'The 8(a) Business Development Program has one-time eligibility.'}
              yesno_with_comment_required_on_yes 'submitted_app_to_8a', 1, title: 'Has the applicant firm ever submitted an application to the 8(a) Business Development Program?'
              yesno_with_attachment_required_on_yes 'previous_participant_assets_over_50_percent', 2, title: 'Do the assets of a previously certified 8(a) Business Development Program Participant constitute 50% or more of applicant firm’s assets?'
            end
            question_section 'eight_a_basic_eligibility_assistance', 3, title: 'Outside Assistance', submit_text: 'Save and continue' do
              yesno_with_attachment_required_on_yes 'outside_consultant', 0, title: 'Did the applicant firm hire an outside consultant to assist with its 8(a) application?'
            end
            question_section 'eight_a_basic_eligibility_size', 4, title: 'Business Size', submit_text: 'Save and continue' do
              yesno 'small_naics', 0, question_override_title: 'Is the applicant firm considered small in accordance with its primary North American Industry Classification System (NAICS) code?', disqualifier: {value: 'no', message: ' To qualify for the 8(a) Business Development Program, the applicant firm must meet SBA’s small business size standards. Please email 8aBD@sba.gov for assistance if you are unsure if the firm meets SBA’s small business size standards. Include your firm name, DUNS number and address in the email.'}
              yesno 'formal_determination', 1, title: 'Has the applicant firm or any of its affiliates received a formal SBA size determination?'
              question_section 'eight_a_basic_eligibility_size_determination', 0, title: 'Size Determination', submit_text: 'Save and continue' do
                null_with_attachment_required 'redetermination_letter', 0, question_override_title: 'Please upload the size determination or redetermination letter(s) issued by SBA.'
                picklist 'sba_area_office', 1, question_override_title: 'Which SBA area office sent the most recent letter?'
                date 'redetermination_date', 2, question_override_title: 'What is the determination date stated in the most recent letter?'
              end
            end
          end
          review_section 'review', 1, title: 'Review', submit_text: 'Submit'
        end
      end

      eight_a_eligibility.create_rules! do
        section_rule 'eight_a_basic_eligibility_screen', 'eight_a_basic_eligibility_involvement'
        section_rule 'eight_a_basic_eligibility_involvement', 'eight_a_basic_eligibility_assistance'
        section_rule 'eight_a_basic_eligibility_assistance', 'eight_a_basic_eligibility_size'
        section_rule 'eight_a_basic_eligibility_size', 'eight_a_basic_eligibility_size_determination', {
            klass: 'Answer', identifier: 'formal_determination', value: 'yes'
        }
        section_rule 'eight_a_basic_eligibility_size', 'review', {
            klass: 'Answer', identifier: 'formal_determination', value: 'no'
        }
        section_rule 'eight_a_basic_eligibility_size_determination', 'review'
      end
    end
=end
  end
end
