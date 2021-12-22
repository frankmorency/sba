class EventLog < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true
end
