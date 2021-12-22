module VendorAdmin
  class MyDocumentsController < VendorAdminController
    before_action :set_current_organization
    before_filter :require_documents_access
    before_action :set_document, only: [:restore, :archive]

    def index
      @active_documents = current_organization.documents.where('document_type_id IS NOT ? AND user_id = ? AND is_active = ?', nil, current_user.id, true)
      # TODO - what about anonymous user?
    end

    def inactive
      @inactive_documents = current_organization.documents.where('document_type_id IS NOT ? AND user_id = ? AND is_active = ?', nil, current_user.id, false)
      render :index
    end

    def restore
      if @document.update!(is_active: true)
        flash[:info] = "Your document was restored."
      else
        flash[:info] = "Your document could not be restored. Please try again."
      end
      redirect_to inactive_vendor_admin_my_documents_path
    end

    def archive
      if @document.update!(is_active: false)
        flash[:info] = "Your document was archived."
      else
        flash[:info] = "Your document could not be archived. Please try again."
      end
      redirect_to vendor_admin_my_documents_path
    end

    private

    def set_document
      @document = current_organization.documents.find(params[:my_document_id])
    end

    def require_documents_access
      raise CanCan::AccessDenied unless can? :view_document_library, current_user
    end
  end
end