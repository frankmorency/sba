class SbaApplicationDocument < ActiveRecord::Base
  include Versionable

  acts_as_paranoid
  has_paper_trail

  belongs_to :document
end
