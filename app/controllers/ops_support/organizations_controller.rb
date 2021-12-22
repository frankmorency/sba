module OpsSupport
  class OrganizationsController < OpsSupportController
    before_action   :set_organization, only: [:show, :update]

    def show
    end

    def update
      if @organization.update_attributes(organization_params)
        render json: {business_type: BusinessType.get(@organization.business_type).display_name}, :status => 200
      else
        render json: {message: 'failure to save'}, :status => 400
      end
    end

    private

    def organization_params
      params.require(:organization).permit(:business_type)
    end

    def set_organization
      @organization = Organization.find(params[:id])
    end

  end
end