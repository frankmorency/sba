class Section
  class Spawner < QuestionSection
    belongs_to  :template, class_name: 'Section::Template'

    validates   :repeat, presence: true
    validates   :template, presence: true

    def template_rules
      template.section_rules.where(sba_application: sba_application)
    end

    def first_rule # could be multiple?
      template_rules.find_by(from_section: nil)
    end

    def last_rule
      section_rule_origins.reload.find_by(is_last: true)
    end

    def decision_question
      if sba_application
        original_section.question_presentations.get_decider(repeat['decider'])
      else
        question_presentations.get_decider(repeat['decider'])
      end
    end

    def build_sections_and_rules!(answer, new_answered_for_ids)
      return unless decision_question == answer.question

      @section_builder = DynamicSectionBuilder.new(self, answer, new_answered_for_ids)
      @section_builder.update!
    end
  end
end
