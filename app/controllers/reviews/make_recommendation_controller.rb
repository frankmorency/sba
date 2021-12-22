module Reviews
	class MakeRecommendationController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    before_action   :ensure_non_terminal_cert

    steps :decision, :upload_letters, :reassign_case, :review, :done

    def show

      case step
        when :upload_letters
          @recommendation = Recommendation.new
          session.delete(:determination_document) unless session[:determination_document].nil?
          session.delete(:analysis_document) unless session[:analysis_document].nil?
        when :review
          @recommendation = Recommendation.new(recommendation_params)
        when :done
          @review.recommend(Recommendation.new(recommendation_params))
          @recommendation = Recommendation.new(recommendation_params)
          set_recommendation_title
          if @review.is_out_of_cycle?
            record_recommendation(@sba_application, current_user, 'recommendation', @recommendation.recommend_eligible)
            case @recommendation.recommend_eligible
              when 'termination_recommended'
                @review.recommended_termination!
              when 'voluntary_withdrawal_recommended'
                @review.recommended_voluntary_withdrawal!
              when 'early_graduation_recommended'
                @review.recommended_early_graduation!
            end
          else
            record_recommendation(@sba_application, current_user, 'recommendation', @recommendation.decision.downcase)
            if @recommendation.recommend_eligible == 'true'
              ApplicationController.helpers.log_activity_application_state_change('recommended_eligible', @sba_application.id, current_user.id)
            else
              ApplicationController.helpers.log_activity_application_state_change('recommended_ineligible', @sba_application.id, current_user.id)
            end
          end

          if @sba_application.is_really_a_review?
            send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @recommendation.individual.id, nil, @recommendation.individual.email, @sba_application.organization.name, @sba_application.case_number)
          else
            send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @recommendation.individual.id, @sba_application.id, @recommendation.individual.email, @sba_application.organization.name)
          end
        else
          @recommendation = Recommendation.new
      end
      render_wizard
    end

    def update
      @recommendation = Recommendation.new(recommendation_params)
      case step
        when :review
          unless session[:determination_document].nil?
            create_determination_letter
            session.delete(:determination_document)
          end

          unless session[:analysis_document].nil?
            create_analysis_letter
            session.delete(:analysis_document)
          end
      end
      redirect_to wizard_path(@next_step, recommendation: {recommend_eligible: @recommendation.recommend_eligible, recommend_eligible_for_appeal: @recommendation.recommend_eligible_for_appeal,individual_id: @recommendation.individual_id})
    end

    private

    def set_recommendation_title
      if @recommendation&.recommend_eligible == 'termination_recommended'
        @recommendation_title = 'Terminated'
      elsif @recommendation&.recommend_eligible == 'voluntary_withdrawal_recommended'
        @recommendation_title = 'Voluntary Withdrawn'
      elsif @recommendation&.recommend_eligible == 'early_graduation_recommended'
        @recommendation_title = 'Early Graduated'
      else
        @recommendation_title = 'Recommend ineligible'
      end
    end

    def recommendation_params
      params.require(:recommendation).permit(:recommend_eligible, :recommend_eligible_for_appeal, :individual_id)
    end

    def record_recommendation(application, evaluator, category, value)
      EvaluationHistory.new.record_evaluation_event(application, evaluator, category, value)
    end
  end
end
