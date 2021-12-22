class CurrentApplication < ActiveRecord::Base
  belongs_to :certificate
  belongs_to :sba_application
end
