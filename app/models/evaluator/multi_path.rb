class Evaluator
  class MultiPath
    attr_accessor :app, :template_rule, :current_rule, :expression

    def initialize(rule, expression, app_id)
      @app = SbaApplication.find(app_id)
      @expression = expression

      @current_rule = rule
      @template_rule = rule

      true
    end

    def update_applicability
      # update the defer_applicability_for
    end

    def update_section_rules
      SectionRule.transaction do
        @template_rule.generated_rules.destroy_all

        expression['rules'].each do |rule|
          section_name = rule.keys.first
          exp = rule[rule.keys.first]
          section = next_section(section_name)

          if Evaluator.eval_expression(current_rule, exp, app.id)
            current_rule.to_section_id = section.id
            current_rule.save!
            @current_rule = SectionRule.new(dynamic: true, generated_from: template_rule, from_section_id: current_rule.to_section_id, sba_application: app, questionnaire: app.questionnaire)
            section.update_attribute(:is_applicable, true)
          else
            section.update_attribute(:is_applicable, false)
          end
        end

        current_rule.to_section = template_rule.terminal_section
        current_rule.save!

        template_rule.terminal_section.update_attribute(:is_applicable, true)

        app.update_skip_info!
      end
    end

    def update_skip_info!
      expression['rules'].each do |rule|
        section_name = rule.keys.first
        exp = rule[rule.keys.first]
        section = next_section(section_name)

        if Evaluator.eval_expression(current_rule, exp, app.id)
          current_rule.skip_info['applicable'] << section.name
          current_rule.skip_info['notapplicable'].delete(section.name)
        else
          current_rule.skip_info['notapplicable'] << section.name
          current_rule.skip_info['applicable'].delete(section.name)
        end
      end

      current_rule.skip_info['notapplicable'].uniq!
      current_rule.skip_info['applicable'].uniq!

      current_rule.save!
      current_rule.skip_info
    end

    def next_section(section_name)
      app.sections.find_by(name: section_name)
    end
  end
end