# this should be in the SBA Application controller now

class QuestionnairesController < ApplicationController
  before_action  :set_questionnaire
  before_action  :authenticate_user!, unless: :anonymous_questionnaire?

  def show
    redirect_to section_path_helper(@questionnaire.sections.first, true)
  end

  private

  def questionnaire_params
    params.require(:id)
  end
end
