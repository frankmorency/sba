class Contributor < ActiveRecord::Base
  after_create :setup_contributor

  belongs_to :section
  belongs_to :sba_application
  belongs_to :sub_application, class_name: "SbaApplication::SubApplication"

  before_destroy :disassociate_from_business

  acts_as_paranoid
  has_paper_trail

  def self.for_sub_application(sub_app)
    where(sub_application_id: sub_app.id)
  end

  def is_vendor?
    name == "contributor_va_eight_a_disadvantaged_individual"
  end

  def is_contributor?
    !is_vendor?
  end

  def details
    [application_section, sub_application, questionnaire_name, sba_application]
  end

  def questionnaire_name
    application_section.questionnaire.name
  end

  def application_section
    sba_application.sections.find_by(name: section_name)
  end

  def self.expire!
    joins("left outer join users on users.email=contributors.email").
      select("contributors.*, users.id as user_id").where("users.id is null").where("expires_at <= ?", Date.today).each do |contributor|
      contributor.section.children.find_by(description: contributor.email).update_attribute(:status, Section::INVITATION_EXPIRED)
    end
  end

  def revoke!(name = nil)
    transaction do
      User.transaction do
        unless name.nil?
          # Destroy the sub section
          contributor_subsection = section.children.find_by(name: name)
          contributor_subsection.destroy
        end

        # Need to process roles to keep roles map hash correct not just removing the role.
        user = User.find_by(email: self.email)

        org = self.sba_application.organization

        if user
          user.roles_map = nil
          user.organizations.destroy(user.organizations.first) if user.organizations.first
          user.save!
        end

        ContributorMailer.revoked(email, full_name, org.default_user.id, org.legal_business_name).deliver if org.default_user

        destroy
      end
    end
  end

  def section_name
    # add position to the end
    "#{section.name}_#{full_name.gsub(/\W+/, "").split.map(&:underscore).join("_")}_#{position}"
  end

  #returns an array of all applications this contributor is assigned to.
  def sba_applications
    Contributor.where(:email => self.email).map(&:sba_application)
  end

  private

  def disassociate_from_business
    user = User.find_by(email: self.email)
    if user
      user.personnels.where(organization_id: sba_application.organization_id).destroy_all
      user.roles_map = nil
      user.save!
    end
  end

  def setup_contributor
    # add business partners?  answered_for?
    transaction do
      sub_app = Section::SubApplication.create!(name: section_name, title: full_name, sba_application: sba_application, questionnaire: section.sub_questionnaire, status: Section::NOT_STARTED, parent: section, description: email, position: position)
      sub_app
    end
  end
end
