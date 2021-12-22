class Section
  class SpawnersController < QuestionSectionsController
    def edit
      super

      @owners = BusinessPartner.to_params @questions.first
    end

    def update
      BusinessPartner.transaction do
        brand_new_answered_for_ids, data = BusinessPartner.from_params(@sba_application, strip_empties(owner_params))

        this_question_presentation = QuestionType::OwnerList.first.questions.first.question_presentations.find_by(section: @section.original_section)

        answer_params[this_question_presentation.id.to_s][:value] = data

        @user.set_answers(answer_params, sba_application: @sba_application, section: @section, brand_new_answered_for_ids: brand_new_answered_for_ids)
      end

      super
    end

    private

    def owner_params
      params.require(:owners)
    end

    def strip_empties(list)
      list.reject do |h|
        h[:id].blank? && h[:full_name].blank? && h[:last_name].blank? && h[:ssn].blank? && h[:email].blank? && h[:address].blank? && h[:city].blank? && h[:state].blank? && h[:postal_code].blank? && h[:country].blank? && h[:home_phone].blank? && h[:business_phone].blank?
      end
    end
  end
end
