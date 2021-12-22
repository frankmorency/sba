class Group < ActiveRecord::Base
  include NameRequirements

  acts_as_paranoid
  has_paper_trail

  belongs_to :program
end
