module VendorAdmin
  class VoluntarySuspensionsController < VendorAdminController
    def new
      new_voluntary_suspension
    end

    def create
      if new_voluntary_suspension(voluntary_suspension_params).save
        redirect_to [:vendor_admin, :voluntary_suspension]
      else
        render :new
      end
    end

    def show
      voluntary_suspension
    end

    private

    def voluntary_suspension
      @voluntary_suspension ||= current_organization.voluntary_suspension
    end

    def new_voluntary_suspension(attrs = {})
      @voluntary_suspension ||= current_organization.build_voluntary_suspension(attrs)
    end

    def voluntary_suspension_params
      params.require(:voluntary_suspension).permit(:id, :option, :certificate_id, :title, :body, :document, :suspension_duration_months)
    end
  end
end
