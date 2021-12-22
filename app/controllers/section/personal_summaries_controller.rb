class Section
  class PersonalSummariesController < BaseController
    def edit
      @answer_proxy = @sba_application.answers
      @sba_application_id = @sba_application.id
      @questions = []
      @business_partner = @section.answered_for.nil? ? current_user : @section.answered_for
      @personal_summary = ::PersonalSummary.new(@business_partner, @sba_application.has_agi?, @sba_application_id)
      @assets = @personal_summary.assets.answers
      @liabilities = @personal_summary.liabilities.answers
      @agi = @personal_summary.agi.hide_agi? ? nil : @personal_summary.agi.answers
      @income = @personal_summary.income.answers
      super
    end

    def update
      @questions = []

      super
    end
  end
end
