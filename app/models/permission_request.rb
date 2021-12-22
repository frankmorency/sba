class PermissionRequest < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :access_request
  belongs_to :user
  
  scope :for_approval, ->{ where(action: [1, 2]) }
  
  enum action: {
    requested: 0,
    accepted: 1,
    rejected: 2,
    revoked: 3,
    expired: 4,
  }
  
end
