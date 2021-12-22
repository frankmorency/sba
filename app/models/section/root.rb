class Section
  class Root < Section
    before_save   :set_non_displayable, unless: :single_page?

    delegate  :single_page?, to: :questionnaire
  end
end
