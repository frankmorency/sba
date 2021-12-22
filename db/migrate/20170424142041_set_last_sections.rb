class SetLastSections < ActiveRecord::Migration
  def change
    
    section_ids = []

    questionnaires = ['eight_a_disadvantaged_individual', 'eight_a_business_partner', 'eight_a_spouse' ]

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