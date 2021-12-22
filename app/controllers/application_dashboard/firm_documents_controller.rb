module ApplicationDashboard
  class FirmDocumentsController < BaseController
    before_action :set_is_analyst_value
    before_action :set_all_unfiltered_documents

    def index
      if ((can? :ensure_contributor, current_user) || (can? :ensure_vendor, current_user))
        @user_id = current_user.id
      else
        @user_id = nil
      end

      @is_active = true
      set_active_firm_documents
      set_inactive_firm_documents

      if (can? :ensure_contributor, current_user)
        render template: 'contributors/application_dashboard/firm_documents/index'
      elsif (can? :ensure_vendor, current_user)
        render template: 'vendor_admin/application_dashboard/firm_documents/index'
      else
        render :index
      end
    end

    def user_filter
      if ((can? :ensure_contributor, current_user) || (can? :ensure_vendor, current_user))
        @user_id = current_user.id
      else
        @user_id = params[:user_id] || nil
      end

      @is_active = to_boolean(params[:is_active])
      set_active_firm_documents
      set_inactive_firm_documents

      if (can? :ensure_contributor, current_user)
        render template: 'contributors/application_dashboard/firm_documents/index'
      elsif (can? :ensure_vendor, current_user)
        render template: 'vendor_admin/application_dashboard/firm_documents/index'
      else
        render :index
      end
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
      @is_analyst_value = false
    end
  end
end