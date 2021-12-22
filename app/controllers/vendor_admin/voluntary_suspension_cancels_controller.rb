class VendorAdmin::VoluntarySuspensionCancelsController < VendorAdminController

  def update
    voluntary_suspension.cancel!
    redirect_to [:vendor_admin, :voluntary_suspension]
  end

  private

  def voluntary_suspension
    @voluntary_suspension ||= current_organization.voluntary_suspension
  end
end
