module Admin
  class DocumentTypesController < BaseController
    def index
      @doc_types = DocumentType.all.order(name: :asc)
    end
  end
end