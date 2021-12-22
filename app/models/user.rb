class User < ActiveRecord::Base
  include Answerable
  include Searchable
  include UserPermissions
  include ActiveModel::Dirty

  acts_as_paranoid
  has_paper_trail
  rolify

  searchable fields: {
    "Name" => "first_name",
  }, default: "Name", per_page: 10

  if Feature.active?(:idp)
    attr_accessor :password
    devise :validatable, :omniauthable, omniauth_providers: %i[sba_idp]
  else
    devise :database_authenticatable, :registerable,
           :recoverable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable, :omniauthable, :omniauth_providers => [:saml]
  end

  after_save :update_roles
  after_create :associate_contributor

  has_many :access_requests
  has_many :permission_requests

  # has_and_belongs_to_many :duty_stations
  has_many :offices
  has_many :duty_stations, through: :offices

  # has_and_belongs_to_many :business_units
  has_many :office_locations
  has_many :business_units, through: :office_locations

  has_many :answers, as: :owner

  # has_and_belongs_to_many :organizations
  has_many :personnels
  has_many :organizations, through: :personnels

  has_many :documents
  has_many :assigned_applications, class_name: "SbaApplication", foreign_key: :returned_reviewer_id

  has_many :agency_requirements

  has_many :sam_organizations

  accepts_nested_attributes_for :sam_organizations

  validates :first_name, :last_name, presence: true
  validates :phone_number, format: { with: /\A\d{3}-\d{3}-\d{4}\z/, allow_blank: true, message: "format should be XXX-XXX-XXXX" }
  validate :password_complexity

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!=@$%^&*-]).{12,70}$/

    errors.add :password, "Complexity requirement not met. Length should be 12-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end

  def self.filter_by_duty_stations_and_roles(ds_names, roles)
    User.joins(:duty_stations, :roles).where(duty_stations: { name: ds_names }).where(roles: { name: roles }).group(:id)
  end

  if !Feature.active?(:idp)
    def self.from_omniauth(saml_hash, provider)
      user_data = Hash.new
      saml_hash.each do |element|
        user_data[element["Name"]] = element["AttributeValue"]
      end

      raise "MaxId is required but is missing in the Max.gov response" unless user_data["maxId"]

      max_user = unscoped.where(uid: user_data["maxId"]).first
      # if we have an user always update attributes in our database
      if max_user
        max_user.update_attributes!({
          provider: provider,
          uid: user_data["maxId"],
          email: user_data["maxEmail"],
          password: Devise.friendly_token,
          max_user_classification: user_data["maxUserClassification"],
          max_agency: user_data["maxAgency"],
          max_org_tag: user_data["maxOrgTag"],
          max_group_list: user_data["maxGroupList"],
          first_name: user_data["maxFirstName"],
          last_name: user_data["maxLastName"],
          deleted_at: nil, #user resurection in our systems.
          # max params even if they are redundant
          max_security_level_list: user_data["maxSecurityLevelList"],
          max_last_name: user_data["maxLastName"],
          max_first_name: user_data["maxFirstName"],
          max_email: user_data["maxEmail"],
          max_bureau: user_data["maxBureau"],
          max_id: user_data["maxId"],
        })
      else # else we want to create a user in our database
        begin
          max_user = where(uid: user_data["maxId"]).first_or_create! do |user|
            user.provider = provider
            user.uid = user_data["maxId"]
            user.email = user_data["maxEmail"]
            user.password = Devise.friendly_token
            user.max_user_classification = user_data["maxUserClassification"]
            user.max_agency = user_data["maxAgency"]
            user.max_org_tag = user_data["maxOrgTag"]
            user.max_group_list = user_data["maxGroupList"]
            user.first_name = user_data["maxFirstName"]
            user.last_name = user_data["maxLastName"]
            # max params even if they are redundant
            user.max_security_level_list = user_data["maxSecurityLevelList"]
            user.max_last_name = user_data["maxLastName"]
            user.max_first_name = user_data["maxFirstName"]
            user.max_email = user_data["maxEmail"]
            user.max_bureau = user_data["maxBureau"]
            user.max_id = user_data["maxId"]
            user.skip_confirmation!
          end
        rescue ActiveRecord::RecordInvalid => e
          max_user = find_by_email(user_data["maxEmail"])
          max_user.update_attributes!({
            provider: provider,
            uid: user_data["maxId"],
            email: user_data["maxEmail"],
            password: Devise.friendly_token,
            max_user_classification: user_data["maxUserClassification"],
            max_agency: user_data["maxAgency"],
            max_org_tag: user_data["maxOrgTag"],
            max_group_list: user_data["maxGroupList"],
            first_name: user_data["maxFirstName"],
            last_name: user_data["maxLastName"],
            deleted_at: nil, #user resurection in our systems.
            # max params even if they are redundant
            max_security_level_list: user_data["maxSecurityLevelList"],
            max_last_name: user_data["maxLastName"],
            max_first_name: user_data["maxFirstName"],
            max_email: user_data["maxEmail"],
            max_bureau: user_data["maxBureau"],
            max_id: user_data["maxId"],
          })
        end
      end
      max_user
    end
  else
    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_create.tap do |user|
        user.email ||= auth.info.email
        user.first_name ||= auth.info.first_name
        user.last_name ||= auth.info.last_name
        user.phone_number ||= "123-456-7890"
        user.password ||= "I @m a fake password"
        user.max_id ||= auth.info.max_id
        user.uuid ||= auth.info.uuid
        # A workaround to identify govt users, since IdP does not send auth.info.max_id value yet
        if user.max_id.nil? && ([".gov", ".mil", ".fed.us"].include? user.email.split("@").last)
          user.max_id = "max_id_not_found"
        end
        user.save
      end
    end
  end

  def self.get_password_strength(password)
    strength = ""

    case User.get_password_entropy(password)
    when 0...18
      strength = "weak"
    when 18...30
      strength = "average"
    when 30..200
      strength = "strong"
    end
    strength
  end

  def self.get_password_entropy(password)
    StrongPassword::StrengthChecker.new(password).calculate_entropy
  end

  def self.ops_support_search(query, user_type)
    case user_type
    when "gov_user"
      User.gov_user_search(query)
    when "vendor_user"
      User.vendor_user_search(query)
    end
  end

  def self.vendor_user_search(query)
    if query.present?
      query = "%#{query}%"
      where("max_id IS NULL AND (first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?)", query, query, query)
    end
  end

  def self.gov_user_search(query)
    if query.present?
      query = "%#{query}%"
      where("max_first_name ILIKE ? OR max_last_name ILIKE ? OR max_email ILIKE ?", query, query, query)
    end
  end

  def self.analysts_and_supervisors
    User.where("roles_map#>>'{Legacy}' LIKE  ?", "%supervisor%") + User.where("roles_map#>>'{Legacy}' LIKE ?", "%analyst%")
  end

  def add_fake_doc!
    Document.create!(organization_id: organization_id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: DocumentType.first, is_active: true, user_id: id)
  end

  def workload(role = nil)
    SbaApplication::EightAMaster
    SbaApplication::ASMPPMaster
    SbaApplication::EightAInfoRequest

    # TODO: Do we really want to scope to eight_a?

    apps = if role == :district_office_supervisor
        SbaApplication::MasterApplication.do_supervisor_assigned_cases(self).to_a
      elsif role == :cods_supervisor
        SbaApplication::MasterApplication.where(bdmis_case_number: nil).assigned_workload(id).to_a
      else
        SbaApplication::MasterApplication.assigned_workload(id).to_a
      end

    apps + Review::OutOfCycle.not_cancelled.assigned_to(self)
  end

  def duty_station
    duty_stations.first
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def cannot_view_answers?(app)
    !can_view_answers?(app)
  end

  def can_view_answers?(app)
    return true if is_sba_or_ops?
    return true if is_vendor_or_contributor? && app&.creator == self

    return true if app&.master_application_id && app&.master_application&.kind == SbaApplication::INFO_REQUEST && app&.master_application&.creator == self

    false
  end

  def assign_role?
    return self.can_any? :assign_8a_role_cods, :assign_8a_role_hq_program, :assign_wosb_role, :assign_mpp_role, :assign_8a_role_hq_aa, :assign_8a_role_district_office, :assign_8a_role_hq_ce, :assign_8a_role_ops, :assign_8a_role_size, :assign_8a_role_hq_legal, :assign_8a_role_oig
  end

  def update_answers(answer_params, app, sub_app_section = nil)
    transaction do
      set_answers answer_params, sba_application: app
      app.update_deferred!
      if app.is_a? SbaApplication::SubApplication
        section = sub_app_section
        section = app.master_application.sub_application_sections.find_by(sub_questionnaire_id: app.questionnaire_id) unless sub_app_section

        if section.nil? || !sub_app_section && section.name != app.section.name
          # We have a contributor here.
          section = app.section
        end
        section.update_attribute(:status, Section::IN_PROGRESS)
      end
    end
  end

  def is_servicing_bos?(org)
    eight_a_cert = org.certificates.eight_a.first
    eight_a_cert&.servicing_bos_id == id
  end

  def has_no_orgs?
    organizations.count < 1
  end

  def organization
    one_and_only_org
  end

  def one_and_only_org
    organizations.first
  end

  def name
    "#{first_name} #{last_name}"
  end

  def vendor_kind
    return "Owner" if self.is_vendor?
    return "Contributor" if self.is_contributor?
    return "SBA User"
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def has_access?(org)
    access_requests.where(organization_id: org.id, status: "accepted").order("updated_at desc").try(:first)
  end

  def add_hash_role(opt)
    return false unless SbaOrganizationMapping.is_roles_hash_correct?(opt)
    return SbaOrganizationMapping.add_hash_role(self, opt)
  end

  def remove_hash_role(opt)
    return false unless SbaOrganizationMapping.is_roles_hash_correct?(opt)
    return SbaOrganizationMapping.remove_hash_role(self, opt)
  end

  def add_hash_role!(opt)
    raise "Invalid hash to add #{opt}" unless SbaOrganizationMapping.is_roles_hash_correct?(opt)
    add_hash_role(opt)
  end

  def remove_hash_role!(opt)
    raise "Invalid hash to remove #{opt}" unless SbaOrganizationMapping.is_roles_hash_correct?(opt)
    remove_hash_role(opt)
  end

  def update_roles
    # only do the update is roles_map feild has changed. for some reason the if: :update_roles synthax does not work
    # And this method was always called.
    if roles_map_changed?
      # This checks that the user json is actually in sync with the SbaOrganizationMapping master hash
      # We will need to eventually remove the wrong roles out of the hash here. Ex:
      # { "Legacy" => { "CO" => "XX", "CO" => "CO" } } should only returns { "Legacy" => { "CO" => "CO" } }

      update_attribute(:roles_map, nil) unless SbaOrganizationMapping.is_user_roles_hash_correct?(self)

      SbaOrganizationMapping.process_roles(self)
    end
  end

  def answer_for(question_name, sba_application_id)
    answers.where(sba_application_id: sba_application_id).joins(:question).find_by("questions.name = ? AND answered_for_id IS NULL", question_name)
  end

  def program_search
    return " "
  end

  def es_filter_program
    if roles.map { |r| r.name == "sba_analyst_8a" || r.name == "sba_supervisor_8a" }.first
      return ["eight_a"]
    elsif roles.map { |r| r.name == "sba_analyst_wosb" || r.name == "sba_supervisor_wosb" }.first
      return ["wosb", "edwosb"]
    elsif roles.map { |r| r.name == "sba_analyst_mpp" || r.name == "sba_supervisor_mpp" }.first
      return ["mpp"]
    else
      return ["eight_a", "wosb", "edwosb", "mpp"]
    end
  end

  def my_eight_a_cases_count
    Review::EightA.my_cases_count(self)
  end

  def my_eight_a_cases
    Review::EightA.my_cases(self)
  end

  def is_vendor?
    return true if can_any?(:ensure_vendor)
    false
  end

  def contributor
    is_contributor? && Contributor.where(:email => email).last
  end

  def is_contributor?
    return true if can_any?(:ensure_contributor)
    false
  end

  def is_vendor_or_contributor?
    return true if can_any?(:ensure_vendor, :ensure_contributor)
    false
  end

  def is_sba?
    return true if can_any?(:sba_user)
    false
  end

  def is_sba_or_ops?
    return true if can_any?(:sba_user, :ensure_ops_support)
    false
  end

  def associate_contributor
    contributor = Contributor.where(:email => email)&.last
    if contributor
      contributor.update_attribute(:user_id, id)
    end
  end
end
