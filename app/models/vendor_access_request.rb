class VendorAccessRequest < AccessRequest
  before_validation :set_defaults, on: :create
end
