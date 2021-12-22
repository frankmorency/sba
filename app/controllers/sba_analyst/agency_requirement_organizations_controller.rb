module SbaAnalyst
  class AgencyRequirementOrganizationsController < SbaAnalystController

    before_filter :set_agency_requirement, :only => [:new, :create, :destroy]

    def new
      @agency_requirement_organization = AgencyRequirementOrganization.new
    end

    def create
      @agency_requirement_organization = AgencyRequirement.find(params[:agency_requirement_id]).agency_requirement_organizations.new
      duns_id =  request.params[:duns_number]
      @organization = Organization.find_by(duns_number: duns_id)

      if @organization.nil?
        flash[:error] = "Invalid DUNS for organization."
        redirect_to :back
        return
      end
      if @agency_requirement_organization.agency_requirement.agency_requirement_organizations.pluck(:organization_id).include?(@organization.id)
        flash[:error] = "Firm cannot be duplicates."
        redirect_to :back
        return
      end
      @agency_requirement_organization.organization_id = @organization.id
                  
      if @agency_requirement_organization.save
        flash[:success] = "Firm #{@organization.name} successfully added."
        redirect_to :back
      else
        flash[:error] = AgencyRequirementOrganization::STANDARD_UPLOAD_ERROR_MSG
        redirect_to :back
      end
    end

    def destroy
      @agency_requirement_organization = @agency_requirement.agency_requirement_organizations.find(params[:id])

      if @agency_requirement_organization.destroy
        flash[:success] = "File #{@agency_requirement_organization.organization.name} was successfully deleted."
      else
        flash[:error] = "Failed to delete  #{@agency_requirement_organization.organization.name}."
      end
      redirect_to :back
    end

    private

    def set_agency_requirement
      @agency_requirement = AgencyRequirement.find(params[:agency_requirement_id])
    end

  end
end