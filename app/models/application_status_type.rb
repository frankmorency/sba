class ApplicationStatusType < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :sba_applications
end
