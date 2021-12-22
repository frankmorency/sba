class EligibleNaicCode < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :certificate_type
end
