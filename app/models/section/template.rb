require 'securerandom'

class Section
  class Template < Section
    has_many    :sections
    has_many    :section_rules, foreign_key: 'template_root_id'
    belongs_to  :sub_questionnaire, class_name: 'Questionnaire::SubQuestionnaire'

    before_create :set_sub_q_status, if: :is_sub_q_template

    before_save   :set_type_to_question_section, unless: :template_type?, on: :create

    def customize_title(value)
      title.blank? ? value : title.gsub('{value}', value)
    end

    def is_sub_q_template
      template_type == 'Section::SubQuestionnaire'
    end

    def class_path
      raise "Templates are used for generating new sections only and should not be referenced in URLs"
    end

    private

    def set_type_to_question_section
      self.template_type = "Section::QuestionSection"
    end
  end
end
