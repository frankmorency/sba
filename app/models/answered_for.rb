class AnsweredFor
  ANSWERED_FOR_CLASSES = ['BusinessPartner']

  def self.factory(app_id, data)
    return nil unless data['answered_for_type'] && data['answered_for_id']

    if ANSWERED_FOR_CLASSES.include?(data['answered_for_type']) && ! data['answered_for_id'].blank?
      model = data['answered_for_type'].constantize.find(data['answered_for_id'])

      if model && model.sba_application_id != app_id
        raise Error::DataManipulation.new("Trying to set invalid business partner data on an answer")
      else
        model
      end
    else
      nil
    end
  end
end