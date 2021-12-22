FactoryBot.define do
  factory :vendor_admin, class: User do
    first_name  'Vendor'
    last_name  'Guy'
    sequence(:email) { |n| "vendor_guy#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation "Not@allthepassword1"
      # sequence(:confirmation_token) {|n| "CgmvRKDtqr8349nxri3oeuSf4oAK8YVendorGuy#{n}"}
    end

  end

  factory :user do
    first_name "mike"
    last_name "morgan"
    email "applicant1@mailinator.com"
    password "Not@allthepassword1"

    if !Feature.active?(:idp)
      password_confirmation "Not@allthepassword1"
      confirmation_token "CgmvRKDtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui"
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
  end

  factory :user_random, class: User do
    first_name 'mike'
    last_name 'morgan'
    sequence(:email) { |n| "applicant#{n+Time.now.to_i}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "CgmvRKDtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
  end

  factory :user_with_org, class: User do
    first_name 'Whoever'
    last_name 'morgan'
    sequence(:email) { |n| "whoever#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      confirmation_token 'CgmvRKDtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruefui'
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
    after(:create) {|user| user.organizations = [create(:organization)]}
  end

  factory :analyst_user, class: User do
    first_name 'My'
    last_name 'Analyst'
    sequence(:email) {|n| "analyst_#{Time.now.to_i}_#{n}@mailinator.com"}
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "dfjaskeflijasdlfkjasldfkjf3urfyuiryefnyruebhirewfhuirfui_#{Time.now.to_i}_#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
    roles {[FactoryBot.create(:sba_analyst_wosb_role)]}
  end

  factory :ops_support_admin_user, class: User do
    first_name 'Admin'
    last_name 'Support'
    sequence(:email) {|n| "ops_support_admin_#{Time.now.to_i}_#{n}@mailinator.com"}
    password 'password1PASSWORD1!'
    password_confirmation 'password1PASSWORD1!'
    # sequence(:confirmation_token) {|n| "dfjaskeflijasdlfkjasldfkjf3asdfasfyefnyruebhirewfhuirfui_#{Time.now.to_i}_#{n}"}
    confirmed_at Time.now
    roles_map '{"Legacy":{"SUPPORT":["admin"]}}'
    before(:create) {|user| user.skip_confirmation!}
    roles {[FactoryBot.create(:sba_ops_support_admin_role)]}
  end

  factory :ops_support_staff_user, class: User do
    first_name 'Staff'
    last_name 'Support'
    sequence(:email) {|n| "ops_support_staff_#{Time.now.to_i}_#{n}@mailinator.com"}
    password 'password1PASSWORD1!'
    password_confirmation 'password1PASSWORD1!'
    # sequence(:confirmation_token) {|n| "dfjaskeflijasdlfkjasdf234yuiryefnyruebhirewfhuirfui_#{Time.now.to_i}_#{n}"}
    confirmed_at Time.now
    roles_map  '{"Legacy":{"SUPPORT":["staff"]}}'
    before(:create) {|user| user.skip_confirmation!}
    roles {[FactoryBot.create(:sba_ops_support_staff_role)]}
  end

  factory :sba_supervisor_8a_cods, class: User do
    first_name 'Cod8'
    last_name 'Supervisor'
    email 'super8cod@mailinator.com'
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      confirmation_token 'CgmvRKDtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui1'
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
    roles {[FactoryBot.create(:sba_supervisor_8a_cods_role)]}
  end

  factory :sba_supervisor_user, class: User do
    first_name 'My'
    last_name 'Supervisor'
    sequence(:email) {|n| "super_#{Time.now.to_i}_#{n}@mailinator.com"}
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "asldfkjasdflkjasdflkajsdfiejf_#{Time.now.to_i}_#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
    roles {[FactoryBot.create(:sba_supervisor_wosb_role)]}
  end

  factory :sba_user, class: User do
    first_name 'SBA'
    last_name 'User'
    sequence(:email) {|n| "sba_user_#{Time.now.to_i}_#{n}@mailinator.com"}
    password 'password'

    if !Feature.active?(:idp)
      password_confirmation 'password'
      # sequence(:confirmation_token) {|n| "dkasdlifwelfkjasdlkjasdvjoaiwefalsdfjk#{Time.now.to_i}_#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
  end

  factory :vendor_user, class: User do
    first_name 'My'
    last_name 'Analyst'
    sequence(:email) { |n| "vendor_#{Time.now.to_i}_#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "CgmvRKDtqoeuSf4oAK8Yasdkfjalsdfkj_#{Time.now.to_i}_#{n}"}
    end

    confirmed_at Time.now

    after(:build) do |user|
      if !Feature.active?(:idp)
        user.skip_confirmation!
      end
      user.roles << build(:vendor_admin_role)
    end
  end

  factory :vendor_user_with_org, class: User do
    first_name 'MyOrg'
    last_name 'Analyst'
    sequence(:email) { |n| "vendor_#{Time.now.to_i}_#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "CgmvRKDewhdkf3urfyuiryefnyruebhirewfhuirfui_#{Time.now.to_i}_#{n}"}
    end

    confirmed_at Time.now

    after(:build) do |user|
      if !Feature.active?(:idp)
        user.skip_confirmation!
      end
      user.roles << build(:vendor_admin_role)
      user.organizations = [build(:organization)]
    end
  end

  factory :contributor_user, class: User do
    first_name 'My'
    last_name 'Contributor'
    sequence(:email) { |n| "contributor_#{Time.now.to_i}_#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "contributor-CgmvRKDtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui_#{n}"}
    end

    confirmed_at Time.now

    after(:build) do |user|
      if !Feature.active?(:idp)
        user.skip_confirmation!
      end
      user.roles << build(:contributor_role)
    end
  end

  factory :federal_contracting_officer, class: User do
    first_name 'My'
    last_name 'Contracting Officer'
    email 'co1@mailinator.com'
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      confirmation_token 'DtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui'
      before(:create) { |user| user.skip_confirmation! }
    end

    confirmed_at Time.now
    roles {[FactoryBot.create(:federal_contracting_officer_role)]}
  end

  factory :eight_a_cods_analyst_user, class: User do
    first_name 'My'
    last_name 'Cods Analyst User'
    sequence(:email) { |n| "sba_analyst_8a_cods_#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "eight_a_cods_analyst_user-DtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end

    roles {[FactoryBot.create(:sba_analyst_8a_cods_role)]}
  end

  factory :eight_a_user, class: User do
    first_name 'My'
    last_name 'Eight A User'
    sequence(:email) { |n| "sba_8a_user_#{n}@mailinator.com" }
    password 'password1PASSWORD1!'

    if !Feature.active?(:idp)
      password_confirmation 'password1PASSWORD1!'
      # sequence(:confirmation_token) {|n| "eight_a_cods_analyst_user-DtqoeuSf4oAK8Y_ewhdkf3urfyuiryefnyruebhirewfhuirfui#{n}"}
      confirmed_at Time.now
      before(:create) {|user| user.skip_confirmation!}
    end
  end

end
