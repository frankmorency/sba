class UpdateInfoRequestQuestionnaire < ActiveRecord::Migration
  def change
    q = Questionnaire::EightAInfoRequest.first
    q.root_section.update_attribute :title, '8(a) Information Request'
    q.first_section.update_attribute :title, '8(a) Information Request'
    section = q.sections.find_by(name: 'signature')
    # only way it works...
    ActiveRecord::Base.connection.execute("UPDATE sections SET is_last = 't' WHERE id = #{section.id};")
  end
end
