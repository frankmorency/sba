class Country < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  validates :name, :iso_alpha2_code, presence: true
end
