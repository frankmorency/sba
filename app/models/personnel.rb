class Personnel < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :organization
  belongs_to :user
end
