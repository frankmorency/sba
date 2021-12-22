class WhyIsThisNecessary < ActiveRecord::Migration
  def change
    section_ids = []

    questionnaires = ['adhoc_text_and_attachment']

    questionnaires.each do |q|
      Questionnaire.where(name: q).each do |p|
        section_ids <<  p.sections.where(name: 'review').first.id
        p.sba_applications.each do |app|
          section_ids << app.sections.where(name: 'review').first.id
        end
      end
    end

    section_ids.each do |id|
      query = "UPDATE sections SET is_last = 't' WHERE id = #{id};"
      ActiveRecord::Base.connection.execute(query)
    end
  end
end
