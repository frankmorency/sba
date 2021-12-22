require 'will_paginate/array'
module SbaAnalyst
  class AgencyRequirementsController < SbaAnalystController

    before_action :set_agency_requirement, only: [:show, :edit, :update, :destroy, :firms, :add_firm]

    def index
      redirect_to sba_analyst_agency_requirements_search_index_path
    end

    def new
      set_select_options
      @us_states = us_states
      @agency_requirement = AgencyRequirement.new
    end

    def add_firm
      respond_to do |format|
        if @agency_requirement.update(agency_requirement_params)
          @agency_requirement_organization =  @agency_requirement.agency_requirement_organizations.last
          flash[:success] =  @agency_requirement_organization.organization.name + " was successfully updated."
          format.html { redirect_to :back }
        else
          flash[:error] = "Agency Requirement was not updated."
          format.html { redirect_to :back }
        end
      end
    end

    def delete_firm
      o_id = params[:o_id]
      @agency_r_o = AgencyRequirementOrganization.find(o_id)
      if @agency_r_o.destroy
        organization_json = {info: "Deleted!", id: o_id}
      else
        organization_json = {info: "Error", id: o_id}
      end
      render json: organization_json
    end

    def firms
      @organizations = @agency_requirement.agency_requirement_organizations
      @agency_ro = AgencyRequirementOrganization.new
    end

    def update
      if agency_co_params_present?
        @agency_co = @agency_requirement.build_agency_co(agency_co_params)
        if @agency_co.invalid?
          flash[:error] = @agency_co.errors.full_messages.join(", ")
          redirect_to :back
          return
        end
      else
        @agency_co = @agency_requirement.agency_co
      end
      respond_to do |format|
        params['agency_requirement']['received_on'] = Date.strptime(params['agency_requirement']['received_on'], '%m/%d/%Y') if !params['agency_requirement']['received_on'].blank?
        if @agency_requirement.update(agency_requirement_params)
          @agency_requirement.agency_co.save if @agency_requirement.agency_co
          flash[:success] = "Agency Requirement was successfully updated."
          format.html { redirect_to sba_analyst_agency_requirement_path(@agency_requirement) }
        else
          flash[:error] = @agency_requirement.errors.full_messages.join(", ")
          redirect_to :back
        end
      end
    end

    def create
      set_select_options
      @agency_co = AgencyCo.new(agency_co_params)

      if !@agency_co.email.blank? || !@agency_co.first_name.blank? || !@agency_co.last_name.blank?
        if @agency_co.save
          params["agency_requirement"]["agency_co_id"] = @agency_co.id
        end
      end
      params['agency_requirement']['received_on'] = Date.strptime(params['agency_requirement']['received_on'], '%m/%d/%Y') if !params['agency_requirement']['received_on'].blank?
      @agency_requirement = AgencyRequirement.new(agency_requirement_params)
      respond_to do |format|
        if @agency_requirement.save
          flash[:success] = "Agency Requirement " + @agency_requirement.title  + " successfully created"
          format.html { redirect_to sba_analyst_agency_requirement_path(@agency_requirement) }
        else
          flash[:notice] = "Agency Requirement not created"
          format.html { render :new }
        end
      end
    end

    def show
    end

    def destroy
      respond_to do |format|
      end
    end

    def edit
      set_select_options
      @us_states = us_states
    end

    def download
      @agency_requirement = AgencyRequirement.find(params[:agency_requirement_id])
      respond_to do |format|
        format.csv { send_data @agency_requirement.to_csv, filename: "#{@agency_requirement.unique_number}_export.csv" }
      end
    end


    def get_agency_naics
      naics_code =  request.params[:agency_naics]
      agency_naics_code = AgencyNaicsCode.find_by(code: naics_code)
      if agency_naics_code.nil? || naics_code.blank?
        organization_json = {
          name: "No Valid NAICS Entered"
        }
      else
        organization_json = {
            id: agency_naics_code.id,
            name: agency_naics_code.industry_title,
            size: agency_naics_code.size
        }
      end

      render json: organization_json
    end

    def get_duns
      duns_id =  request.params[:duns]
      organization = Organization.find_by(duns_number: duns_id)
      if organization.nil?
        organization_json = {
            name: "No Valid DUNS Entered"
        }
      else
        organization_json = {
            id: organization.id,
            name: organization.name
        }
      end

      render json: organization_json
    end

    def agency_requirement_params
      params.require(:agency_requirement).permit(
          :user_id, :organization_id, :duty_station_id, :agency_naics_code_id, :agency_office_id, :agency_offer_code_id,
          :agency_offer_type_id, :agency_offer_scope_id, :agency_offer_agreement_id, :agency_contract_type_id, :agency_co_id,
          :title, :description, :received_on, :estimated_contract_value, :contract_value, :offer_solicitation_number , :offer_value,
          :contract_number, :agency_comments, :contract_comments, :comments, :program_id, :contract_awarded, agency_requirement_organizations_attributes: [:id, :agency_requirement_id, :organization_id]
      )
    end

    def agency_co_params
      params.require(:agency_co).permit(
          :first_name, :last_name, :phone, :email, :address1,
          :address2, :city, :state, :zip
      )
    end

    private

    def set_agency_requirement
      @agency_requirement = AgencyRequirement.find(params[:id])
    end

    def set_select_options
      @agency_office_options = AgencyOffice.order(:name).map {|m| [m.display_name, m.id] }
      @offer_agreement_options = AgencyOfferAgreement.all.pluck(:name, :id)
      @offer_scope_options = AgencyOfferScope.all.pluck(:name, :id)
      @offer_code_options = AgencyOfferCode.all.pluck(:name, :id)
      @duty_station_options = DutyStation.all.order('name ASC').pluck(:name, :id)
      @agency_contract_options = AgencyContractType.all.pluck(:name, :id)
    end

    def agency_co_params_present?
      !agency_co_params["first_name"].blank? || !agency_co_params["last_name"].blank? || !agency_co_params["email"].blank?
    end

  end
end
