require 'clamav/client'
namespace :av do
  task scan_files: :environment do
    if `pgrep "rake av:scan_files"` == ""
      # Get all unscanned documents
      scan(Document.where(:av_status => "Not Scanned"))
      scan(AgencyRequirementDocument.where(:av_status => "Not Scanned"))
    end
  end

  def scan(docs)
    @av_status = AvStatusHistory.new
    @av_status.start_time =  Time.new

    @docs = docs
    @av_status.total_documents = @docs.count

    @av_status.save!
    @error_count = 0
    @docs.each do |doc|
      begin
        file = nil
        if doc.is_word_doc? || doc.is_excel_doc?
          file = Document.get_file_stream(doc.folder_name, doc.stored_file_name, doc.original_file_name)
        else
          file = Document.get_pdf_object(doc.folder_name, doc.stored_file_name)
        end
        client = ClamAV::Client.new
        @io = StringIO.new file
        clamav_out = client.execute(ClamAV::Commands::InstreamCommand.new(@io))
        av_status = nil
        case clamav_out
        when ClamAV::SuccessResponse
          av_status = "OK"
        when ClamAV::VirusResponse
          av_status = "Infected"
          @error_count += 1
        when ClamAV::ErrorResponse
          av_status = "Error"
        end
        doc.av_status = av_status
        doc.save!
      rescue Exception => e
        message =  "Problem encountered during virus scan of message #{doc.folder_name}|#{doc.stored_file_name}|#{doc.original_file_name}: #{e.message}"
        Rails.logger.error message
        ExceptionNotifier.notify_exception(e, data: {message: message}) if Rails.env.production?
      end
    end
    @av_status.end_time = Time.new
    @av_status.total_errors = @error_count
    @av_status.save!
  end
end
