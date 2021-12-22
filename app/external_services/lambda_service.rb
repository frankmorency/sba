require 'aws-sdk'

class LambdaService
  def invokeZipFunction bucket_name, folder_name, files, files_in_zip, zip_file_name
    # orignial files could miss extension, fixing names
    files_fixed = []
    files.each do |file|
      unless file.include? ".pdf"
        file = "#{file}.pdf"
      end
      files_fixed << file
    end
    client = Aws::Lambda::Client.new(region: ENV['AWS_REGION'])
    payload = {:region => ENV['AWS_REGION'], :bucket => bucket_name, :folder => folder_name, :files => files_fixed, :filesInZip => files_in_zip, :zipFileName => zip_file_name}
    resp = client.invoke({function_name: ENV['ZIP_LAMBDA_FUNCTION_NAME'], invocation_type: "Event", payload: payload.to_json})
  end
end
