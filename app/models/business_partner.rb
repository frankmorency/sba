class BusinessPartner < ActiveRecord::Base
  include Versionable

  ALL_FIELDS = %w(first_name last_name title ssn marital_status address city state country postal_code home_phone business_phone email).map(&:to_sym)

  acts_as_paranoid
  has_paper_trail

  belongs_to :sba_application
  has_many :dynamic_sections, class_name: "Section", as: :answered_for, dependent: :destroy
  has_many :answers, as: "answered_for", dependent: :destroy

  # NOTE: ONLY ADD TO THE END OF THIS LIST OR EXISTING STATUSES WILL CHANGE !!!
  enum title: %w(Owner President Officer Partner Spouse Other)
  enum marital_status: %w(Unmarried Married Separated)
  enum status: %w(start in_progress completed)

  validates :first_name, uniqueness: { scope: [:last_name, :sba_application_id, :deleted_at], case_insensitive: true, message: "owners full name must be unique per application" }
  validates :ssn, format: /\A(\d{3}-?\d{2}-?\d{4}|XXX-XX-XXXX)\z/
  validates :email, format: { with: Devise::email_regexp }

  ALL_FIELDS.each do |field|
    validates field.to_sym, presence: true
  end

  def self.to_params(question)
    return [] if question.value.blank?

    owners = []
    JSON.parse(question.value).each do |id, data|
      owners << BusinessPartner.find(data["id"])
    end

    owners.sort { |x, y| x.id.to_i <=> y.id.to_i }
  end

  def self.from_params(app, data)
    existing_ids = app.business_partners.pluck(:id).map(&:to_s)

    brand_new_answer_ids = []

    data.each do |attrs|
      id = attrs.with_indifferent_access.delete("id").try(:to_s)

      attrs = attrs.permit(ALL_FIELDS) if attrs.respond_to?(:permit)

      if id.blank?
        if old_one = app.business_partners.find_by(first_name: attrs["first_name"], last_name: attrs["last_name"])
          existing_ids.delete(old_one.id)
          old_one.destroy
        end

        brand_new_answer_ids << app.business_partners.create!(attrs).id
      elsif existing_ids.include? id
        existing_ids.delete(id)
        app.business_partners.find(id).update_attributes(attrs)
      end
    end

    app.business_partners.where(id: existing_ids).destroy_all unless existing_ids.empty?

    old_format = {}
    app.business_partners.reload.each do |bp|
      old_format[bp.id.to_s] = bp.attributes
    end

    [brand_new_answer_ids, old_format]
  end

  def answer_for(question_name, sba_application_id)
    answers.where(sba_application_id: sba_application_id).joins(:question).find_by("questions.name = ?", question_name)
  end

  def name
    "#{first_name} #{last_name}"
  end
end
