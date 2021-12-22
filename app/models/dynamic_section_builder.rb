class DynamicSectionBuilder
  attr_accessor :app, :template_root, :spawner, :answer, :sections, :data

  def initialize(spawner, answer, brand_new_answered_for_ids)
    @spawner, @answer = spawner, answer
    @data = []
    @template_root = spawner.template
    @app = spawner.sba_application
    @index = -1
    @brand_new_answered_for_ids = brand_new_answered_for_ids
  end

  def update!
    ActiveRecord::Base.transaction do
      update_sections!
      delete_rules!
      create_rules!

      @app.section_rules.order('id asc').each do | rule |
        Rails.logger.debug "SECTION_RULE:#{@app.id}: #{rule.from_section.name} (#{rule.from_section.id}) -> #{rule.to_section.name} (#{rule.to_section.id}) : #{rule.expression}"
      end

      @app.update_skip_info!
    end
  end

  def template_rules
    @spawner.template_rules.where('from_section_id IS NOT NULL')
  end

  def first_rule
    @spawner.first_rule
  end

  def last_rule
    @spawner.last_rule
  end

  def repeat
    spawner.repeat
  end

  def update_sections!
    sorted_values = answer.value['value'].values.select {|x| x['id'] }.sort {|x,y| x['id'] <=> y['id'] }

    sorted_values += answer.value['value'].values.select {|x| !x['id'] }

    sorted_values.each do |value|
      if repeat['model'] == 'BusinessPartner'
        biz_partner = get_biz_partner(value['id'].to_i)

        # CREATE NEW SECTION
        if @brand_new_answered_for_ids.include?(biz_partner.id)
          create_section biz_partner.name, spawner, template_root, repeat['starting_position'] + @index
        else
          # UPDATE SECTION
          app.sections.where(answered_for: biz_partner).each do |section|
            section.update_attributes(
                name: section.template.customize_name(biz_partner.name),
                title: section.template.customize_title(biz_partner.name)
            )
          end
        end
        # DELETE SECTION happens given cascading deletes on BusinessPartner
      end
    end
  end

  def get_biz_partner(id)
    biz_partner = answer.sba_application.business_partners.find(id)
    @data[@index += 1] = {
        # this should be dynamic based on the :model set in the :repeat json
        model: biz_partner,
        value: biz_partner.name,
        sections: []
    }
    biz_partner
  end

  def delete_rules!
    app.section_rules.where(dynamic: true).destroy_all
    app.section_rules.where(is_last: true).update_all(from_section_id: @spawner.id)
  end

  def create_rules!
    previous_rule = nil

    @data.each_with_index do |data, i|
      value = data[:value]

      if i == 0
        # create the transition from spawner to first section
        previous_rule = app.section_rules.create!(
            from_section: spawner,
            to_section: first_rule.to_template_section(@app, value),
            questionnaire: app.master,
            dynamic: true
        )
      end

      template_rules.each do |rule|
        if rule.from_section && rule.to_section
          # continuing in the current set (save Business Partner)
          previous_rule = app.section_rules.create!(
              from_section: rule.from_template_section(app, value),
              to_section: rule.to_template_section(app, value),
              questionnaire: app.master,
              dynamic: true
          )
        elsif data != @data.last && rule.from_section
          # transitioning to the next set (new Business Partner)
          next_value = @data[i + 1][:value]
          previous_rule = app.section_rules.create!(
              from_section: rule.from_template_section(@app, value),
              to_section: first_rule.to_template_section(@app, next_value),
              questionnaire: app.master,
              dynamic: true
          )
        else
          if data != @data.last
            raise "Unable to handle rule transition: #{rule.debug}"
          end
        end
      end
    end

    if previous_rule # update the very last rule
      last_rule.update_attribute(:from_section, previous_rule.to_section)
    end
  end

  private

  def create_section(name, pops, template, i, &block)
    section = template.template_type.constantize.create! questionnaire: app.master, submit_text: template.submit_text, name: template.customize_name(name), title: template.customize_title(name), answered_for: @data.last[:model], template: template, sba_application: @app, parent: pops, position: i, dynamic: true, validation_rules: template.validation_rules

    @data[@index - 1][:sections] << section

    block.call(section) if block_given?

    template.children.order(:position).each_with_index do |child, i|
      create_section(name, section, child, i, &block)
    end
  end
end
