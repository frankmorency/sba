module Reviews
  class DeficiencyLetterController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    # Currently Removing the step to review the message (Discused with kim)
    # steps :decide_action, :compose_message, :review, :return_to_firm
    steps :compose_message, :return_to_firm


    def show
      @return = MasterAppReturner.new master_app_returner_params

      if step == :compose_message
        @return = MasterAppReturner.new master_app_returner_params
        @return.deliver_to = @sba_application.organization.owner_name
      end

      render_wizard
    end

    def update
      if step == :compose_message
        @return = MasterAppReturner.new(master_app_returner_params)
        @return.letter = true

        @sba_application.deficiency_letter_return!(@return, current_user)
        ApplicationController.helpers.log_activity_application_state_change('returned', @sba_application.id, current_user.id)
      else
        @return = MasterAppReturner.new(master_app_returner_params)
        @return.letter = true
      end

      redirect_to wizard_path(@next_step, master_app_returner: {letter: @return.letter})
    end

    private

    def master_app_returner_params
      params.permit(:subject, :deliver_to, :letter, :message)
    end
  end
end
