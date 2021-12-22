module Reviews
  class RetainFirmController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :compose_message, :review, :done

    def show
      case step
        when :compose_message
          @deliver_to = @sba_application.organization.owner_name
        when :done
          review = @sba_application.current_review
          review.retain_firm!
          review.save!
      end
      render_wizard
    end

    def update
      case step
        when :compose_message
          session[:deliver_to] = params[:deliver_to]
          session[:subject] = params[:subject]
          session[:message] = params[:message]
        when :review
          if Feature.active?(:notifications)
            @retain_firm = EightARetainFirm.new
            @retain_firm.subject = session[:subject]
            @retain_firm.message = session[:message]
            send_official_message(@retain_firm, current_user, @sba_application.organization.default_user, @sba_application)
            session.delete(:subject)
            session.delete(:message)
          end

          record_retainment(@sba_application, current_user, 'determination', 'retain')
      end
      redirect_to wizard_path(@next_step)
    end

    private

    def retain_firm_params
      params.permit(:deliver_to, :subject, :deliver_to, :message)
    end

    def record_retainment(application, evaluator, type, value)
      EvaluationHistory.new.record_evaluation_event(application, evaluator, type, value)
    end

  end
end
