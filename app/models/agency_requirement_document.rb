class AgencyRequirementDocument < ActiveRecord::Base
  include Searchable
  include S3Document

  acts_as_paranoid
  has_paper_trail

  belongs_to :user
  belongs_to :agency_requirement

  AGENCY_DOCUMENT_TYPES = ["Letter of Offer", "SOW", "Acceptance", "Other"]

  after_initialize :set_stored_file_name

  before_validation :set_av_status, on: :create

  validates_presence_of :stored_file_name, :original_file_name,
                        :av_status, :user_id, :agency_requirement_id, :document_type

  validates :document_type, :inclusion => { :in => AgencyRequirementDocument::AGENCY_DOCUMENT_TYPES }
  validate :valid_file_type

  searchable fields: {
    "Name" => "original_file_name",
    "Type" => "document_type.name",
    "Date" => "created_at",
    "Comments" => "comment",
    "Status" => "is_active",
  }, default: "Name", per_page: 10

  def file_key
    "#{folder_name}/#{stored_file_name}"
  end

  def check_av_status
    set_av_status if self.new_record?
  end

  def set_stored_file_name
    float_time = "%10.5f" % Time.now.to_f
    self.stored_file_name = SecureRandom.uuid + "-" + float_time.to_s if self.stored_file_name.blank?
  end

  def folder_name
    agency_requirement.folder_name
  end

  def valid_file_type
    suffix = File.extname(original_file_name).downcase
    types = AgencyRequirementDocument::MIME_TYPES.keys
    self.errors.add :base, "Please upload files of the following types only: #{types.join(", ")}" unless types.include? suffix
  end
end
