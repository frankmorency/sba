FactoryBot.define do
  factory :access_request do
    association :user, factory: :vendor_user_with_org
    status 'requested'
    after(:build) do |ar|
      ar.organization = ar.user.organizations.first
    end
  end 

  factory :vendor_profile_access_request,
          class: VendorAccessRequest,
          parent: :access_request do
    solicitation_naics '123123'
    roles_map = { "Legacy" => { "VENDOR" => ["admin"] } }
  end

  factory :vendor_role_access_request,
          class: VendorRoleAccessRequest,
          parent: :access_request do
    roles_map = { "Legacy" => { "VENDOR" => ["admin"] } }
  end
end
