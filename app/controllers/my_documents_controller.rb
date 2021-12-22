class MyDocumentsController < VendorAdminController
  before_filter :require_documents_access
  before_action :set_current_organization

  def index
  	@documents = current_organization.documents.where('document_type_id IS NOT ? AND user_id = ?', nil, current_user.id)
  	# TODO - what about anonymous user?
  end

  private

    def require_documents_access
      raise CanCan::AccessDenied unless can? :view_document_library, current_user
    end
end
