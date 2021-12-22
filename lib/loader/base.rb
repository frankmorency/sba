module Loader
  class Base
    attr_accessor :app, :doc, :user, :org

    def self.load(app_id)
      new(app_id).load!
    end

    def initialize(app_id)
      @app  = SbaApplication.find(app_id)
      set_up
    end

    def set_up
      @org  = @app.organization
      @user = @org.users.first
      @doc  = Document.create!(organization: @org, user: @user, document_type: DocumentType.first, original_file_name: 'FAKE', stored_file_name: 'FAKE', is_active: true)
    end

    def data_for(app)
      JSON.load(Rails.root.join('db', 'fixtures', "#{app.questionnaire.name}.json"))
    end

    def answers(section, data)
      a = {}.with_indifferent_access
      data.each do |k, v|
        q = Question.find_by(name: k) || raise("Unable to find question #{k}")
        qp = q.question_presentations.find_by(section_id: section.id)
        qp_id = qp.id
        a[qp_id] = v
        a[qp_id]["document_ids"] = [doc.id.to_s] if a[qp_id]["document_ids"]
      end
      a
    end

    def finish_sub_app!(name)
      sub_app = if name.is_a?(SbaApplication)
                  name
                else
                  @app.sub_applications.joins(:questionnaire).where('questionnaires.name' => name).first
                end

      data_for(sub_app).each do |data|
        master_section = sub_app.questionnaire.sections.find_by(name: data['section'])
        section = sub_app.sections.find_by(name: data['section'])
        answer_data = answers(master_section, data['answers'])
        user.update_answers(answer_data, sub_app)
        sub_app.advance!(user, section, answer_data)
      end

      sub_app.send(:remove_nonapplicable_answers_and_sections, user)
      sub_app.creator = user
      sub_app.submit!
    end

    def load!
      SbaApplication.transaction do
        data_for(app).each do |data|
          master_section = app.questionnaire.sections.find_by(name: data['section'])
          section = app.sections.find_by(name: data['section']) || raise("Unknown section #{data['section']}")
          answer_data = answers(master_section, data['answers'])
          user.update_answers(answer_data, app)
          app.advance!(user, section, answer_data)
        end

        app.send(:remove_nonapplicable_answers_and_sections, user)
      end
    end
  end
end