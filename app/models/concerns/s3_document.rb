module S3Document
  extend ActiveSupport::Concern

  included do
    scope :nil_compressed_status, -> { where(av_status: "OK").where(compressed_status: nil) }
    scope :ready_for_queueing, -> { where(av_status: "OK").where(compressed_status: COMPRESSED_STATUS[:ready]) }
    scope :ready_for_compression, -> { where(av_status: "OK").where(compressed_status: COMPRESSED_STATUS[:queued]) }
  end

  STANDARD_UPLOAD_ERROR_MSG = "There was an error. Please try again."
  COMPRESSOR_SUFFIX = "_compressed"

  COMPRESSED_STATUS = {
    ready: "ready", queued: "queued", compressed: "compressed",
    failed: "failed", compressed_larger: "compressed_larger",
    below_min: "below_min",
  }.freeze

  MIME_TYPES = {
    ".pdf" => "application/pdf",
    ".doc" => "application/doc",
    ".docx" => "application/docx",
    ".xls" => "application/xls",
    ".xlsx" => "application/xlsx",
  }

  def compressed_stored_file_name
    "#{stored_file_name}#{COMPRESSOR_SUFFIX}"
  end

  def is_word_doc?
    original_file_name.downcase.ends_with?(".doc") || original_file_name.downcase.ends_with?(".docx")
  end

  def is_excel_doc?
    original_file_name.downcase.ends_with?(".xls") || original_file_name.downcase.ends_with?(".xlsx")
  end

  def mime_type
    suffix = File.extname(original_file_name).downcase
    MIME_TYPES[suffix]
  end

  def get_presigned_url
    signer = Aws::S3::Presigner.new
    suffix = File.extname(original_file_name).downcase
    if suffix.blank?
      signer.presigned_url(:get_object, bucket: ENV["AWS_S3_BUCKET_NAME"], key: file_key, expires_in: 30)
    else
      signer.presigned_url(:get_object, bucket: ENV["AWS_S3_BUCKET_NAME"], key: "#{file_key}#{suffix}", expires_in: 30)
    end
  end

  def compressed?
    compressed_status == COMPRESSED_STATUS[:compressed]
  end

  def set_av_status
    self.av_status = "Not Scanned"
  end

  def file_key
    raise NotImplementedError, "subclass did not define bucket_key"
  end

  module ClassMethods
    def encode_pdf_content_to_base64(pdf_data)
      Base64.strict_encode64(pdf_data)
    end

    def get_pdf_object(folder_name, file_name)
      if Rails.env == "development" && !ENV.has_key?("AWS_S3_BUCKET_NAME")
        open("tmp/s3_local/#{folder_name}/#{file_name}.pdf").read
      else
        s3 = S3Service.new
        if s3.check_file_exists(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}")
          s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}").get.body.read
        else
          if file_name.include?(".pdf")
            s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}").get.body.read
          else
            s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}.pdf").get.body.read
          end
        end
      end
    end

    def get_file_stream(folder_name, file_name, original_file_name)
      suffix = File.extname(original_file_name).downcase
      if Rails.env == "development" && !ENV.has_key?("AWS_S3_BUCKET_NAME")
        open("tmp/s3_local/#{folder_name}/#{file_name}#{suffix}").read
      else
        s3 = S3Service.new
        if s3.check_file_exists(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}")
          s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}").get.body.read
        else
          if File.extname(file_name).downcase == suffix
            s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}").get.body.read
          else
            s3.get_file_object(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{file_name}#{suffix}").get.body.read
          end
        end
      end
    end

    def is_pdf?(file)
      begin
        File.open(file.tempfile, "rb") do |io|
          reader = PDF::Reader.new(io)
          #reader = PDF::Reader.new(file)
        end
      end
      true
    rescue StandardError => e
      puts e
      false
    end

    def make_association(associated_model, document_ids)
      document_ids.each do |document_id|
        next if associated_model.document_ids.include?(document_id.to_i)
        document = find(document_id)
        associated_model.documents << document if document
      end
    end

    def destroy_answer_document_associations(answer_id, document_ids)
      document_ids.each do |document_id|
        AnswerDocument.find_by(document_id: document_id, answer_id: answer_id).destroy
      end
    end

    def upload_document(folder_name, document_content, stored_file_name, original_file_name = nil)
      puts "hit upload document in s3_document.rb"
      if %(development test).include?(Rails.env) && !ENV.has_key?("AWS_S3_BUCKET_NAME")
        suffix = File.extname(original_file_name).downcase
        FileUtils::mkdir_p "tmp/s3_local/#{folder_name}"
        # TODO: Can this be replaced with file open as below, is there a reason for this to be copy stream
        # IO.copy_stream(document_content, "tmp/s3_local/#{folder_name}/#{stored_file_name}.pdf")
        File.open("tmp/s3_local/#{folder_name}/#{stored_file_name}#{suffix}", "wb") { |f| f.write(document_content) }
        true
      else
        if !original_file_name.nil?
          suffix = File.extname(original_file_name).downcase
          if suffix.blank?
            S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}", document_content)
          else
            S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}#{suffix}", document_content)
          end
        else
          S3Service.new.upload_file(ENV["AWS_S3_BUCKET_NAME"], "#{folder_name}/#{stored_file_name}.pdf", document_content)
        end
      end
    end
  end
end
