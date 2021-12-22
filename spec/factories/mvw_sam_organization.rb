FactoryBot.define do
  factory :mvw_sam_organization do
    association :user, factory: :vendor_user_with_org    
    
    after(:build) do |ar|
      ar.organization = ar.user.organizations.first
    end
  end 
end  

