class Reconsideration
  include ActiveModel::Model

  attr_accessor :topic, :message_to_firm_owner, :sub_section_name #, :text, :attachment, 

  def unique_name
    "#{topic.split(/\W+/).map(&:downcase).join("_")}_#{Time.now.to_i}"
  end

  def questionnaire_type
    Questionnaire::RECONSIDERATION
  end
end