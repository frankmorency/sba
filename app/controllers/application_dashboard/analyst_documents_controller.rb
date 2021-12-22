module ApplicationDashboard
  class AnalystDocumentsController < BaseController
    before_action :ensure_sba_user
    before_action :set_is_analyst_value
    before_action :set_all_unfiltered_documents

    def index
      @user_id = nil
      @is_active = true
      set_active_firm_documents
      set_inactive_firm_documents
      @permissions = Permissions.build(current_user, @sba_application)
    end

    def set_active_firm_documents
      @active_firm_documents = @sba_application.all_documents(@user_id, true, @is_analyst_value)
    end

    def set_inactive_firm_documents
      @inactive_firm_documents = @sba_application.all_documents(@user_id, false, @is_analyst_value)
    end

    def to_boolean(str)
      return true if str=="true"
      return false if str=="false"
      return nil
    end

    def set_is_analyst_value
      @is_analyst_value = true
    end
  end
end