class Document < ActiveRecord::Base
  include Searchable
  include S3Document

  acts_as_paranoid
  has_paper_trail

  attr_reader :organization_id
  belongs_to :document_type
  belongs_to :organization
  belongs_to :user
  has_many :answer_documents
  has_many :answers, through: :answer_documents
  has_many :sba_application_documents
  has_many :sba_applications, through: :sba_application_documents
  has_many :review_documents
  has_many :reviews, through: :review_documents
  before_validation :set_av_status, on: :create

  searchable fields: {
    "Name" => "original_file_name",
    "Type" => "document_type.name",
    "Date" => "created_at",
    "Comments" => "comment",
    "Status" => "is_active",
  }, default: "Name", per_page: 10

  def file_key
    "#{organization.folder_name}/#{stored_file_name}"
  end

  def folder_name
    organization.folder_name
  end
end
