module Reviews
  class FinalizeAdverseActionController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    before_action   :ensure_non_terminal_cert, only: [:update]

    steps :adverse_action, :documents_analysis, :add_a_note, :review, :finish

    def show
      @adverse_action = params.dig(:adverse_action)&.to_sym
      set_adverse_action_title
      delete_session_variables if step == :adverse_action
      render_wizard
    end

    def update
      set_session_variables
      case step
        when :review
          # Create note
          note = Note.create!(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: session[:note_subject], body: session[:note_message], author_id: current_user.id, published: true, tags: session[:note_tags])
          #ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, note.id)

          # Create new document
          unless session[:analysis_document].nil?
            create_analysis_letter
          end
          # Update review status
          new_state = session[:adverse_action] + '!'
          @review.send(new_state)
          @review.save!
          @review.current_assignment.destroy if @review.current_assignment

          @certificate = @review.certificate
          @certificate.send(new_state)
          @certificate.expiry_date = Date.today
          @certificate.save!
          @sba_application = @review.sba_application
          if @sba_application
            record_determination(@sba_application, current_user, 'determination', session[:adverse_action])
            @sba_application.send(new_state)
            @sba_application.save!
          else
            record_determination(@review, current_user, 'determination', session[:adverse_action])
          end

          log_activity
        when :finish
          delete_session_variables
      end
      redirect_to wizard_path(@next_step, adverse_action: session[:adverse_action])
    end

    private

    def record_determination(application, evaluator, category, value)
      EvaluationHistory.new.record_evaluation_event(application, evaluator, category, value)
    end

    def set_adverse_action_title
      return if params[:adverse_action].blank?
      case session[:adverse_action]
        when 'finalize_early_graduation'
          @adverse_action_title = 'Early graduation'
          @adverse_action_text = 'Early Graduation'
          @adverse_action_text_pt = 'Early Graduated'
        when 'finalize_termination'
          @adverse_action_title = 'Send termination to HQ'
          @adverse_action_text =  'Termination'
          @adverse_action_text_pt =  'Terminated'
        when 'finalize_voluntary_withdrawal'
          @adverse_action_title = 'Voluntary withdrawal'
          @adverse_action_text = 'Voluntary Withdrawal'
          @adverse_action_text_pt = 'Voluntary Withdrawn'
      end
    end

    def log_activity
      state_change = nil

      case session[:adverse_action]
        when 'recommended_early_graduation'
          state_change = 'determined_early_graduation'
        when 'recommended_termination'
          state_change = 'determined_termination'
        when 'recommended_voluntary_withdrawal'
          state_change = 'withdrawal_accepted'
      end

      unless state_change.nil?
        ApplicationController.helpers.log_activity_application_state_change(state_change, @sba_application.id, current_user.id)
      end
    end

    def invalid_note_params?
      params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
    end

    def set_session_variables
      session[:adverse_action] = params[:adverse_action] if params[:adverse_action].present?
      session[:individual_id] = params[:individual_id] if params[:individual_id].present?
      session[:analysis_document] = params[:analysis_document] if params[:analysis_document].present?
      session[:note_subject] = params[:note_subject] if params[:note_subject].present?
      session[:note_message] = params[:note_message] if params[:note_message].present?
      session[:note_tags] = params[:note_tags] if params[:note_tags].present?
    end

    def delete_session_variables
      session.delete(:adverse_action)
      session.delete(:individual_id)
      session.delete(:analysis_document)
      session.delete(:note_subject)
      session.delete(:note_message)
      session.delete(:note_tags)
    end
  end
end