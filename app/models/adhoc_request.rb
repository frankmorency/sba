class AdhocRequest
  include ActiveModel::Model

  attr_accessor :topic, :message_to_firm_owner, :text, :attachment, :sub_section_name

  def text
    @text == "1"
  end

  def attachment
    @attachment == "1"
  end

  def unique_name
    "#{topic.split(/\W+/).map(&:downcase).join("_")}_#{Time.now.to_i}"
  end

  def questionnaire_type
    if text && attachment
      Questionnaire::ADDHOC_TEXT_AND_ATTACHMENT
    elsif text
      Questionnaire::ADHOC_TEXT
    elsif attachment
      Questionnaire::ADHOC_ATTACHMENT
    else
      raise "You must select text or attachment"
    end
  end
end