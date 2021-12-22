module ContractingOfficer
  class SbaApplicationsController < ContractingOfficerController
    before_action :authenticate_user!
    before_action :require_co_access

    def show
      @organization = Organization.find(params[:organization_id])
      @sba_application = @organization.sba_applications.find(params[:id])

      unless current_user.has_access?(@organization)
        render status: 403
        return
      end

      @user = @organization.default_user
      @sections = @sba_application.get_answerable_section_list
      @answer_proxy = @sba_application.answers

      load_business_partners
    end
  end
end