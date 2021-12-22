# frozen_string_literal: true

require './lib/pdf_compressor'

desc 'Compresses PDFs that are marked as ready in Document'
namespace :compress do
  task pdfs: :environment do
    # Only compress documents that haven't been compressed (nil not false or true)
    # Limit to 1800 documents for now (about 1 hour in duration)
    Document.ready_for_queueing.limit(1_800).order(id: :desc)
            .update_all(compressed_status: Document::COMPRESSED_STATUS[:queued])

    Document.ready_for_compression.limit(1_800).order(id: :desc).each do |document|
      next if document.is_word_doc? || document.is_excel_doc?

      begin
        compressor = PdfCompressor.new(document)
        compressor.compress
      rescue StandardError => e
        message =  "Problem encountered during compression scan #{document.folder_name}|#{document.stored_file_name}|#{document.original_file_name}: #{e.message}"

        Rails.logger.error "RAKE: compress:pdfs #{message}"
        ExceptionNotifier.notify_exception(e, data: { message: message }) if Rails.env.production?

        document.update(compressed_status: Document::COMPRESSED_STATUS[:failed])
      end
    end
  end

  task set_ready: :environment do
    Document.nil_compressed_status.limit(1_800).update_all(compressed_status: Document::COMPRESSED_STATUS[:ready])
  end
end
