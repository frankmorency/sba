module SbaAnalyst
  class QuestionReviewsController < SbaAnalystController
    before_action   :setup_review
    before_action   :load_business_partners, if: :load_business_partners_pre_requirements

    def new
      if @review
        @questionnaire = @review.certificate.certificate_type.initial_questionnaire
        @user = @review.certificate.organization.default_user
        @sba_application = @review.sba_application

        @hide_details = true

        @questions_by_section = {}

        @questionnaire.review_sections.each do |section|
          questions = section.question_presentations
          unless questions.empty?
            @questions_by_section[section.title] = questions.map do |question|
              answer = question.answers.set_for(@sba_application).first

              if answer
                question.value = answer.display_value.is_a?(Hash) ? answer.display_value.to_json : answer.display_value
                question.documents = answer.documents
                question.assessment = answer.assessments.build(assessed_by: current_user, the_assessed: answer)
                question.assessment.valid? # to set the status to the last status
                question.assessments = answer.assessments
                question.comment = answer.comment
                question
              else
                nil
              end
            end.compact

            @questions_by_section.delete(section.title) if @questions_by_section[section.title].empty?
          end
        end

        render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
      else
        flash[:error] = "You must initiate a case review first"
        redirect_to new_sba_analyst_sba_application_reviews_path(@sba_application)
      end
    end
  end
end
