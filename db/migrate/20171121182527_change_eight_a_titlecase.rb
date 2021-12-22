class ChangeEightATitlecase < ActiveRecord::Migration
  def change
    
    # 8(a) Character Title Case Change
    s1 = Questionnaire.find_by(review_page_display_title: '8(A) Character Summary')
    s1.review_page_display_title = "8(a) Character Summary"
    s1.save!

    # 8(a) Control Title Case Change
    s2 = Questionnaire.find_by(review_page_display_title: '8(A) Control Summary')
    s2.review_page_display_title = "8(a) Control Summary"
    s2.save!

    # 8(a) Potential for Success Title Case Change
    s3 = Questionnaire.find_by(review_page_display_title: '8(a) Applicant enters business\'s Potential for Success information')
    s3.review_page_display_title = "8(a) Potential for Success Summary"
    s3.save!

    # 8(a) Basic Eligibility Title Case Change
    s4 = Questionnaire.find_by(review_page_display_title: '8(A) Eligibility Summary')
    s4.review_page_display_title = "8(a) Eligibility Summary"
    s4.save!

  end
end
