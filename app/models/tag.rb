class Tag < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  validates :name, presence: true, uniqueness: true
end
