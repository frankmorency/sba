module Versionable
  extend ActiveSupport::Concern

  included do
    belongs_to  :sba_application
  end

  module ClassMethods
    def for_application(app, question, answered_for = nil)
      find_by(sba_application_id: app.id, question_id: question.is_a?(Integer) ? question : question.unique_id, answered_for: answered_for)
    end
  end
end
