# frozen_string_literal: true

require './lib/tempfile_manager'

class PdfCompressor
  COMPRESSOR_MIN = 5_000_000
  COMPRESSOR_SUFFIX = '_compressed'
  COMPRESSOR_ATTRIBUTES = {
    alpha: 'off', colorspace: 'gray', compress: 'Zip', density: '110', quality: '100', units: 'PixelsPerInch'
  }.freeze

  def initialize(doc)
    @document = doc

    @folder_name = document.organization.folder_name
    @original_file_name = document.original_file_name
    @stored_file_name = document.stored_file_name
    @compressed_stored_file_name = document.compressed_stored_file_name
    @contents = Document.get_pdf_object(folder_name, stored_file_name)
  end

  def compress
    if contents.length <= COMPRESSOR_MIN
      document.update(compressed_status: Document::COMPRESSED_STATUS[:below_min])
      return
    end

    tempfile_manager.create_and_open(stored_file_name, compressed_stored_file_name)
    write_contents(stored_file_name)

    convert

    if tempfile_manager[compressed_stored_file_name].length >= tempfile_manager[stored_file_name].length
      document.update(compressed_status: Document::COMPRESSED_STATUS[:compressed_larger])
      return
    end

    compressed_contents = read_contents(compressed_stored_file_name)
    Document.upload_document(folder_name, compressed_contents, compressed_stored_file_name, original_file_name)

    document.update(compressed_status: Document::COMPRESSED_STATUS[:compressed])
  rescue StandardError => e
    message =  "Problem encountered during compression scan: #{e.message}"

    Rails.logger.error "PdfCompressor#compress: #{message}"
    ExceptionNotifier.notify_exception(e, data: { message: message }) if Rails.env.production?

    document.update(compressed_status: Document::COMPRESSED_STATUS[:failed])
  ensure
    tempfile_manager.close_and_unlink(stored_file_name, compressed_stored_file_name)
  end

  private

  def write_contents(path)
    tempfile_manager[path].write(contents)
  ensure
    tempfile_manager[path].close
  end

  def read_contents(path)
    tempfile_manager[path].read
  ensure
    tempfile_manager[path].close
  end

  def convert
    MiniMagick::Tool::Convert.new do |converter|
      converter_params(converter)

      # Must follow convert parameters!
      converter << tempfile_manager.path(stored_file_name)
      converter << tempfile_manager.path(compressed_stored_file_name)
    end
  end

  def converter_params(converter)
    COMPRESSOR_ATTRIBUTES.each_pair { |attribute, value| converter.send(attribute, value) }
  end

  def tempfile_manager
    @tempfile_manager ||= TempfileManager.new
  end

  attr_reader :document, :contents, :folder_name, :original_file_name, :stored_file_name, :compressed_stored_file_name
end
