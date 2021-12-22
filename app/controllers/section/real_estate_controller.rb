class Section
  class RealEstateController < QuestionSectionsController
    before_action :set_real_estate_type

    def edit
      super

      # why do i have to do this?
      @questions.last.details = @questions.last.details && JSON.parse(@questions.last.details)
    end

    def update
      if answer_params[@section.qp_id_for_question("has_#{@real_estate_type}").to_s]['value'] == 'no'
        # remove the actual real estate details
        real_estate_details = @user.answers.for_application(@sba_application, @section.qp_id_for_question(@real_estate_type))
        real_estate_details && real_estate_details.destroy!

        answer_params[ @section.qp_id_for_question(@real_estate_type).to_s ]['value'] = "[]"
        answer_params[ @section.qp_id_for_question(@real_estate_type).to_s ].reject! {|k, v| %w(0 1 2 3 4 5 6 7 8 9).include?(k) }
      else
        answer_params[ @section.qp_id_for_question(@real_estate_type).to_s ]['value'] = 'complicated'
      end

      super
    end
  end
end
