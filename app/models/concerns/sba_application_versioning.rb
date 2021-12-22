module SbaApplicationVersioning
  extend ActiveSupport::Concern

  included do
    belongs_to :current_sba_application, class_name: 'SbaApplication'

    has_many   :current_answers, class_name: 'Answer', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'
    has_many   :current_reviews, class_name: 'Review', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'
    has_many   :current_business_partners, class_name: 'BusinessPartner', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'
    has_many   :current_sba_application_documents, class_name: 'SbaApplicationDocument', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'
    has_many   :current_documents, class_name: 'Document', through: :current_sba_application_documents
    has_many   :current_sections, class_name: 'Section', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'
    has_many   :current_section_rules, class_name: 'SectionRule', foreign_key: 'sba_application_id', primary_key: 'current_sba_application_id'

    before_validation :set_latest_version, on: :create
    before_validation :update_is_current, on: :create, if: :current_sba_application_id
    after_create      :update_initial_version, unless: :current_sba_application_id
  end

  module ClassMethods
    def current
      where(is_current: true)
    end

    def retrofit
      SbaApplication.where(current_sba_application_id: nil).order(created_at: :desc).group_by {|app| [app.organization_id, app.certificate_type.id] }.each do |details, apps|
        current = nil
        apps.each do |app|
          current = app.id unless app.inactive? || current
          app.update_attributes(current_sba_application_id: current, is_current: app.id == current)
        end

        app_version = 0
        apps = apps.sort_by {|app| app.created_at}
        apps.each do |app|
          app_version = app_version + 1
          app.update_attributes(version_number: app_version)
        end

      end
    end
  end

  def current
    is_current? ? self : current_sba_application
  end

  def deleteable?(user = nil)
    return false unless is_current? && draft? && ! returned?
    return false if info_request?
    return false if kind == SbaApplication::ANNUAL_REVIEW
    return false if is_under_reconsideration?
    return user ? user.can?(:ensure_vendor, user) : true
  end

  def display_version_number
    "Version #{version_number}"
  end

  def has_previous_revision?
    previous_revision
  end

  def previous_revision
    self.class.order(version_number: :desc).where('current_sba_application_id = ? AND version_number < ?', current_sba_application_id, version_number).limit(1).first
  end

  def revisions
    self.class.where(current_sba_application_id: current_sba_application_id).order('application_submitted_at desc')
  end

  def last_version_number
    if current_sba_application_id
      self.class.where(current_sba_application_id: current_sba_application_id).maximum(:version_number) || 0
    else
      0
    end
  end

  private

  def set_latest_version
    self.version_number = last_version_number + 1
    self.is_current = true
  end

  def update_is_current
    revisions.current.update_all is_current: false
    self.is_current = true
  end

  def update_initial_version
    update_attribute(:current_sba_application_id, id)
  end
end