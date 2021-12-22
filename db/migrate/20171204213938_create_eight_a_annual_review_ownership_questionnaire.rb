class CreateEightAAnnualReviewOwnershipQuestionnaire < ActiveRecord::Migration
  def change
    
    qt = QuestionType::CertifyEditableTable.new(name: 'certify_table_payments_distributions_compensation', title: "Certify Table Payments, Distributions, and Compensation")
    qt.question_rules.new mandatory: false, value: 'yes', capability: :add_comment, condition: :always
    qt.save!

    Questionnaire.transaction do
      eight_a_annual_review_ownership = Questionnaire::SubQuestionnaire.create! name: 'eight_a_annual_review_ownership', title: '8(a) Basic Ownership', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Ownership Summary'

      eight_a_annual_review_ownership.create_sections! do
        root 'eight_a_annual_review_ownership_root', 1, title: 'Ownership' do
          question_section 'eight_a_annual_review_ownership_header', 0, title: 'Ownership' do
            question_section 'payments_and_excessive_withdrawals_questions', 0, title: 'Payments and Excessive Withdrawals', submit_text: 'Save and continue', first: true do
              certify_table_payments_distributions_compensation 'certify_table_payments_distributions_compensation', 1, title: 'List all salaries, bonuses, advances, loans, distributions, or dividends paid in the past fiscal year to:<ul><li>Your firm’s owners, officers, or directors</li><li>Outside firms that your firm’s officers or directors own at least 10% of</li><li>Outside firms with an officer, partner, or director who is also an owner, officer, or director of your firm</li></ul>', strategy: "PaymentsDistributionsCompensation"
              yesno_with_attachment_required_on_yes 'payments_and_excessive_withdrawals_q2', 2, title: 'In the past fiscal year, has your firm made outstanding loans to any of the following?<ul><li>Your firm’s owners, officers, or directors</li><li>Shareholders who own more than 10% of your firm’s stock</li><li>Outside firms that your firm’s officers or directors own at least 10% of</li><li>Outside firms with an officer, partner, or director who is also an owner, officer, or director of your firm</li></ul>'
              yesno_with_comment_required_on_yes 'payments_and_excessive_withdrawals_q3', 3, title: 'In the past fiscal year, has your firm made payments to any of the following people — payments that in total exceed the excessive withdrawal thresholds?<ul><li>Your firm’s owners, officers, or directors</li><li>Outside firms that your firm’s officers or directors own at least 10% of</li><li>Outside firms with an officer, partner, or director who is also an owner, officer, or director of your firm</li></ul>'
            end
          end
          review_section 'review', 1, title: 'Review', submit_text: 'Submit'
        end
        Section.where(questionnaire_id: eight_a_annual_review_ownership.id, name: 'review').update_all is_last: true
      end

      eight_a_annual_review_ownership.create_rules! do
        section_rule 'payments_and_excessive_withdrawals_questions', 'review'
      end
    end
  end
end
