class VoluntarySuspension < ActiveRecord::Base
  include ActionView::Helpers::TagHelper
  include S3Document

  belongs_to :organization
  belongs_to :certificate

  belongs_to :reviewed_by, class_name: "User"
  belongs_to :extended_by, class_name: "User"
  belongs_to :denied_by, class_name: "User"

  validates :option, presence: true
  validates :organization, presence: true
  validates :certificate, presence: true
  validates :title, presence: true
  validates :body, presence: true

  if Rails.env == "development"
    def s3_credentials
      { :bucket => "paperclip-lower", :access_key_id => ENV["PAPERCLIP_ACCESS_KEY_ID"], :secret_access_key => ENV["PAPERCLIP_SECERT_KEY"], :s3_region => "us-east-1" }
    end
  elsif Rails.env == "demo"
    def s3_credentials
      { :bucket => "paperclip-lower", :access_key_id => ENV["PAPERCLIP_ACCESS_KEY_ID"], :secret_access_key => ENV["PAPERCLIP_SECERT_KEY"], :s3_region => "us-east-1" }
    end
  else
    def s3_credentials
      { :bucket => ENV["PAPERCLIP_UPPER_BUCKET_NAME"], :access_key_id => ENV["IAM_USER_UPPER_ACCESS_KEY_ID"], :secret_access_key => ENV["IAM_USER_UPPER_SECRET_ACCESS_KEY"], :s3_region => "us-east-1" }
    end
  end

  has_attached_file :document, s3_credentials: lambda { |attachment| attachment.instance.s3_credentials }, validate_media_type: false

  validates_attachment_content_type :document, :content_type => ["application/pdf"]
  validates_attachment_file_name :document, matches: [/pdf\Z/]

  scope :submitted, -> {
          where(denied_at: nil, extended_at: nil)
        }

  scope :extended, -> {
          where.not(extended_at: nil).where(denied_at: nil)
        }

  scope :denied, -> {
          where.not(denied_at: nil)
        }

  def status
    return :active if self.certificate.workflow_state == "active"
    return :denied if self.denied?
    return :extended if self.extended?
    return :submitted if self.submitted?
  end

  def submitted?
    self.denied_at.blank? && self.extended_at.blank?
  end

  def extended?
    self.denied_at.blank? && self.extended_at.present?
  end

  def denied?
    self.denied_at.present?
  end

  # def cancel!
  #   return unless self.extended?
  #   self.certificate.update_attribute(:expiry_date, self.certificate.expiry_date - days_left_till_final_date)
  #   self.certificate.update_attribute(:workflow_state, "active")
  #   # double check this
  # end

  def extend!(who)
    puts "[BEFORE]self.certificate.expiry_date: #{self.certificate.expiry_date.inspect}"
    puts "suspension_duration_months: #{suspension_duration_months}"
    puts "suspension_duration_months: #{suspension_duration_months.months}"
    self.update_attributes(extended_at: DateTime.now, extended_by: who)
    self.certificate.update_attribute(:expiry_date, self.certificate.expiry_date + suspension_duration_months.months)
    self.certificate.update_attribute(:workflow_state, "vsuspend")
    puts "[AFTER]self.certificate.expiry_date: #{self.certificate.expiry_date.inspect}"
    # VendorAdminMailer.notify_vs_approved(self.organization).deliver_now
    # inform or email them theyve been approved until March 12.
    # cron job to change workflow state back to active on march 12 or leave request approval
  end

  def deny!(who)
    update_attributes(denied_at: DateTime.now, denied_by: who)
    VendorAdminMailer.notify_vs_rejected(self.organization).deliver_now
  end

  def body_formatted
    raw(read_attribute(:body).gsub("\n\n", "\n").split(/\n/).map { |line| content_tag("p", line) }.join(""))
  end

  def file_key
    "#{organization.folder_name}/#{document_file_name}"
  end

  def folder_name
    organization.folder_name
  end

  # def configure_document_parameters
  #   float_time = "%10.5f" % Time.now.to_f
  #   @voluntary_suspension.stored_file_name = float_time.to_s
  #   @voluntary_suspension.original_file_name = params[:file].original_filename
  #   @voluntary_suspension.is_active = true
  #   @voluntary_suspension.document_type_id = document_type_id
  #   @voluntary_suspension.av_status = "Not Scanned"
  #   @voluntary_suspension.user_id = current_user.id
  # end

  # def upload_document(folder_name, document_content, stored_file_name, original_file_name)
  #   puts "hit upload document in s3_document.rb"
  #   if %(development test).include?(Rails.env) && !ENV.has_key?("AWS_S3_BUCKET_NAME")
  #     suffix = File.extname(stored_file_name).downcase
  #     FileUtils::mkdir_p "tmp/s3_local/#{folder_name}"
  #     # TODO: Can this be replaced with file open as below, is there a reason for this to be copy stream
  #     # IO.copy_stream(document_content, "tmp/s3_local/#{folder_name}/#{stored_file_name}.pdf")
  #     File.open("tmp/s3_local/#{folder_name}/#{stored_file_name}#{suffix}", "wb") { |f| f.write(document_content) }
  #     true
  #   else
  #     if !original_file_name.nil?
  #       suffix = File.extname(original_file_name).downcase
  #       if suffix.blank?
  #         S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}", document_content)
  #       else
  #         S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}#{suffix}", document_content)
  #       end
  #     else
  #       S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}.pdf", document_content)
  #     end
  #   end
  # end
end
