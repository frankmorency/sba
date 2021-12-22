class BusinessUnit < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :program
  has_many :office_locations
  has_many :users, through: :office_locations
  has_many :offices, through: :users
end
