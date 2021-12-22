class QuestionnaireTextUpdates < ActiveRecord::Migration
  def change
    
    # 8a Eligiblity Questionnaire Update Disqualifier text
    s1 = Questionnaire.get("eight_a_eligibility").sections.find_by(name: 'eight_a_basic_eligibility_screen')
    q1 = s1.questions.find_by(name: 'generate_revenue')
    qp1 = q1.question_presentations.where(section: s1).first
    disqualifier = qp1.disqualifier
    disqualifier.message = 'In order to participate in 8(a) Business Development Program, the applicant firm must demonstrate potential for success by showing that it has been in business in its primary industry for two years, or you will need to request a waiver of this requirement. If the applicant firm has not yet generated revenues, you will not be successful in obtaining a waiver. Please note this is not applicable to entity-owned firms. Please email 8aBD@sba.gov for assistance if you are unsure about the firm’s revenue status. Include your firm name, DUNS number and address in the email.'
    disqualifier.save!

    # 8a DVD Gender question
    s3 = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'gender')
    q3 = s3.questions.find_by(name: 'gender')
    q3.title = "Gender"
    q3.save!

    # Update all instances of Citizenship question within 8(a) questionnaires
    q = Question.find_by_name('us_citizen')
    q.title = "Are you a U.S. Citizen?"
    q.save!

    s = Questionnaire.get("eight_a_spouse").sections.find_by(name: 'eight_a_spouse_us_citizenship')
    s.title = 'U.S. Citizenship'
    s.save!
    qp = q.question_presentations.where(section: s).first
    qp.question_override_title = nil
    qp.save!

    s = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'us_citizenship')
    s.title = 'U.S. Citizenship'
    s.save!

    s = Questionnaire.get("eight_a_business_partner").sections.find_by(name: 'eight_a_business_partner_us_citizenship')
    s.title = 'U.S. Citizenship'
    s.save!
    qp = q.question_presentations.where(section: s).first
    qp.question_override_title = nil
    qp.save!



    # 8a Firm Ownership (Section Title)
    s4 = Questionnaire.get("eight_a_business_ownership").sections.find_by(name: 'ownership')
    s4.title = "Ownership"
    s4.save!

    # 8a Firm Ownership (Question Title)
    s5 = Questionnaire.get("eight_a_business_ownership").sections.find_by(name: 'eight_a_business_ownership_entity')
    s5.title = "Firm Ownership"
    s5.save!



    # 8a Individual Contributors
    s6 = Questionnaire.get("eight_a_initial").sections.find_by(name: 'disadvantaged_individuals')
    s6.title = "Individual Contributors"
    s6.save!

    # 8a Individual Contributors - Vendor Administrator on certify.SBA.gov and 8(a) Applicant
    s7 = Questionnaire.get("eight_a_initial").sections.find_by(name: 'vendor_admin')
    s7.description = "Firm Owner and Individual Claiming Disadvantage (or 'Disadvantaged Individual'):"
    s7.save!

    # 8a Individual Contributors - Please add another 8(a) Applicant, if applicable.
    s8 = Questionnaire.get("eight_a_initial").sections.find_by(title: 'Disadvantaged Individual')
    s8.description = "Please add another Disadvantaged Individual, if applicable."
    s8.save!

    # 8a Individual Contributors - Please add the spouse of any Disadvantaged Individual
    s9 = Questionnaire.get("eight_a_initial").sections.find_by(title: '(8a) Applicant Spouse')
    s9.description = "Please add the spouse of any Disadvantaged Individual."
    s9.save!



    # 8a DVD - Prior 8(a) Involvement
    s10 = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'eigth_a_program_eligibility')
    s10.title = "Prior 8(a) Involvement"
    s10.save!

    # 8a DVD - Prior 8(a) Involvement
    s11 = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'eigth_a_program_involvement')
    s11.title = "Prior 8(a) Involvement"
    s11.save!

    

    # 8a DVD - Social Disadvantage
    s13 = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'eight_a_basis_of_disadvantage')
    s13.title = "Basis of Disadvantage"
    s13.save!

    # 8a DVD - Economic Disadvantage
    s14 = Questionnaire.get("eight_a_disadvantaged_individual").sections.find_by(name: 'transfer_assets')
    s14.title = "Transferred Assets"
    s14.save!

  end
end
