class Section
  class PersonalPrivacyController < SignatureSectionsController
    def edit
      @signature_terms = []

      super
    end
  end
end
