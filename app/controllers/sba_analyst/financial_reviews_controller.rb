module SbaAnalyst
  class FinancialReviewsController < SbaAnalystController
    before_action   :check_params
    before_action   :setup_review
    before_action   :load_business_partners, if: :load_business_partners_pre_requirements

    def new 
      if @review
        @user = @review.certificate.organization.default_user
        @sba_application = @review.sba_application
        
        # Hash to build the personal summary
        @financial_questions_by_section = {}
         
        # Gets buiness partners ( form the personal summary )
        @business_partner_summaries = @business_partner_summaries.select{ |bp| bp[:partner].id == check_params}

        # Retreive all the sections for one of the buisness_partner ( the one from params )
        @person_section = @owners.select{ |o| o.answered_for_id == check_params }.first

        # Creating assessments values.
        @person_section.assessment_accessor = @person_section.assessments.build(assessed_by: current_user, the_assessed: @person_section)
        @person_section.assessment_accessor.valid? # to set the status to the last status
        @person_section.assessments_accessor = @person_section.assessments

        return user_not_authorized if @person_section.blank?
        
        # Retreive the biz_partner obj from the section
        @biz_partner = @person_section.answered_for
        
        # build the hash and assessments ( Still need work on the assessments. )
        @sections = build_sections(@person_section)
        render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
      else
        flash[:error] = "You must initiate a case review first"
        redirect_to new_sba_analyst_sba_application_reviews_path(@sba_application)
      end
    end

    private 

    def check_params
      params.require(:owner).to_i
    end

    def build_sections(person_section)
      person_section.children.each do |section|
        first_question_for_the_section = section.question_presentations.first
        if first_question_for_the_section
          section.assessment_accessor = section.assessments.build(assessed_by: current_user, the_assessed: section)
          section.assessment_accessor.valid? # to set the status to the last status
          section.assessments_accessor = section.assessments
        end
        questions = section.question_presentations
        # Sets up array of questions by sections. 
        unless questions.empty?
          @financial_questions_by_section[section.title] = build_questions(questions)
          @financial_questions_by_section.delete(section.title) if @financial_questions_by_section[section.title].empty?
        end
      end
    end

    def build_questions(questions)
      questions.map do |question|
        answer = question.answers.where(answered_for: @biz_partner).first
        if answer
          question.value = answer.display_value.is_a?(Hash) ? answer.display_value.to_json : answer.display_value
          question.documents = answer.documents
          question.assessment = answer.assessments.build(assessed_by: current_user, the_assessed: answer)
          question.assessment.valid? # to set the status to the last status
          question.assessments = answer.assessments
          question.comment = answer.comment
        end
        question
      end.compact
    end

  end
end