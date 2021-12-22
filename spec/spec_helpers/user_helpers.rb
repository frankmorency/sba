require 'factory_bot'
require_relative '../fixtures/sample_application'

module UserHelpers
  def create_user_with_org
    @user ||= FactoryBot.create :user_with_org
    @user.update_attribute :confirmed_at, Time.now
    @user.add_role :vendor_admin
  end

  def sign_in_as_a_valid_user(user = nil)
    if user
      @user = user
    else
      create_user_with_org
      organization = @user.one_and_only_org
      ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations(duns, tax_identifier_number, tax_identifier_type, sam_extract_code) VALUES ('#{organization.duns_number}', '#{organization.tax_identifier}', '#{organization.tax_identifier_type}', 'A');")
      MvwSamOrganization.refresh
    end
    login_as(@user, :scope => :user)
    @user
  end

  def sign_in_as_a_valid_user_with_application(cert_type, status, versions = 1)
    sign_in_as_a_valid_user
    allow_any_instance_of(Organization).to receive(:default_user).and_return(@user)
    Spec::Fixtures::SampleApplication.load(@user, cert_type, status, versions)
  end

  def create_user_with_application(cert_type, status, versions = 1)
    create_user_with_org
    Spec::Fixtures::SampleApplication.load(@user, cert_type, status, versions)
    reset_user
  end

  def reset_user
    @user = nil # so you can sign in as another user...
  end

  def sign_in_as_a_valid_ops_user
    @user ||= FactoryBot.create :user_opssupport
    @user.update_attribute :confirmed_at, Time.now
    @user.add_role :user_opssupport
    login_as(@user, :scope => :user)
  end

  def sign_in_as_sba_analyst
    @user ||= FactoryBot.create :analyst_user
    @user.update_attribute :confirmed_at, Time.now
    @user.add_role :sba_analyst
    login_as(@user, :scope => :user)
  end

  def sign_in_as_sba_supervisor(user = nil)
    if user
      @user = user
    else
      @user ||= FactoryBot.create :sba_supervisor_user
      @user.update_attribute :confirmed_at, Time.now
    end

    login_as(@user, :scope => :user)
    @user
  end

  def login(user)
    @user = user
    login_as(@user, :scope => :user)
  end

  def as_user(user)
    @user = user
    login_as user, scope: :user
    yield
  end

  def create_user_analyst(role, options = {duty_station: 'Philadelphia'})
    user = FactoryBot.create :analyst_user
    user.update_attribute :confirmed_at, Time.now
    user.add_role role
    user.duty_stations << DutyStation.find_by(name: options[:duty_station])
    user.save!
    user
  end

  def create_user_sba_analyst
    user = FactoryBot.create :analyst_user
    user.update_attribute :confirmed_at, Time.now
    user.add_role :sba_analyst
    user
  end

  def create_user_sba(role, options = {duty_station: 'Philadelphia'})
    user = FactoryBot.create :sba_user, first_name: role, last_name: options[:duty_station]
    user.add_role role
    user.duty_stations <<  DutyStation.find_by(name: options[:duty_station])
    user.save!
    user
  end

  def create_user_ops_user
    user = FactoryBot.create :user_opssupport
    user.update_attribute :confirmed_at, Time.now
    user.add_role :user_opssupport
    user
  end

  def create_stubbed_8a_app_with_active_cert(vendor)
    create(:fake_8a_app_with_active_cert, organization: vendor.organization)
  end

  def create_user_vendor_admin(options = {duns: "111292429", duty_station: 'Philadelphia'})
    user = build(:vendor_admin)
    user.duty_stations << DutyStation.find_by(name: options[:duty_station] || 'Philadelphia')
    if !Feature.active?(:idp)
      user.skip_confirmation!
    end

    user.save!
    org = create(:vendor_admin_org, duns_number: options[:duns])
    # org.entity_owned = false
    org.save!
    create_mat_view_for_org(options[:duns], options[:business_name] || "Da Biz")
    create(:vendor_admin_doc, organization_id: org.id, user_id: user.id)
    VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)
    user
  end
end
