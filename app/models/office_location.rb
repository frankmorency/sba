class OfficeLocation < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :business_unit
  belongs_to :user
end
