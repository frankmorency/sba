class OfficeRequest < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :duty_station
  belongs_to :access_request
end
