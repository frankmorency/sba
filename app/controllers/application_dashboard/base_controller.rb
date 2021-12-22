module ApplicationDashboard
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :set_application
    before_action :validate_application_access
    before_action :set_organization
    before_action :setup_review_permissions
    before_action :set_first_section

    protected

    def set_application
      # this should be a master application

      @sba_application = nil

      if params[:adverse_action_review_id]
        @sba_application = Review::OutOfCycle.get(params[:adverse_action_review_id])
      else
        if current_user.is_vendor_or_contributor?
          @sba_application = current_organization.sba_applications.find(sba_application_id)
        elsif current_user.is_sba? # check to see if the allowed sba users has to be more restricted
          @sba_application = SbaApplication.find_by_id(sba_application_id)
        end

        if @sba_application.nil?
          flash[:alert] = 'We could not find the requested application.'
          redirect_to request.referer || root_path
        elsif ! @sba_application.show_tabs?
          flash[:alert] = 'The requested application could not be displayed.'
          redirect_to request.referer || root_path
        end
      end
    end

    def set_organization
      @organization = @sba_application.organization
    end

    def set_first_section
      @first_section = @sba_application.first_section
    end

    def set_all_unfiltered_documents
      @active_and_inactive_documents = @sba_application.all_documents(nil, true, @is_analyst_value) + @sba_application.all_documents(nil, false, @is_analyst_value)
    end

    def validate_application_access
      if current_user.is_vendor_or_contributor?
        list = @sba_application.organization.users.select{|u| u.id == current_user.id }
        return user_not_authorized if list.empty?
      end
    end


    def set_sub_application
      @sub_application = @organization.sba_applications.find(sub_application_id)
      head :user_not_authorized if @sub_application.master_application != @sba_application
    end

    private

    def sub_application_id
      params.require(:sub_application_id)
    end
  end
end
