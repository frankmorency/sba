class S3Service
  def get_resource
    begin
      Aws::S3::Resource.new
    rescue Aws::S3::Errors::ServiceError
      false
    end
  end

  def get_bucket bucket_name
    begin
      Aws::S3::Resource.new.bucket(bucket_name)
    rescue Aws::S3::Errors::ServiceError
      false
    end
  end

  def upload_file bucket_name, file_identifier, file_content
    begin
      bucket = self.get_bucket(bucket_name)
      bucket.put_object({key: file_identifier, body: file_content, server_side_encryption: "AES256"}) if bucket
      true
    rescue Aws::S3::Errors::ServiceError
      false
    end
  end

  def get_file_object bucket_name, file_identifier
    begin
      bucket = self.get_bucket(bucket_name)
      bucket.object(file_identifier) if bucket
    rescue Aws::S3::Errors::ServiceError
      false
    end
  end

  def check_file_exists bucket_name, file_identifier
    begin
      s3 = AWS::S3.new
      obj = s3.buckets[bucket_name].objects[file_identifier]
      obj.exists?
    rescue Aws::S3::Errors::ServiceError
      false
    end
  end

  def move_to bucket, file_identifier, new_file_identifier
    s3 = AWS::S3.new
    obj = s3.buckets[bucket_name].objects[file_identifier]

    return false unless obj.present?

    obj.move_to(bucket: bucket, key: new_file_identifier)
  rescue Aws::S3::Errors::ServiceError
    false
  end

  def list_files_in_folder bucket, prefix1, prefix2 = ""
    client = Aws::S3::Client.new
    prefix = prefix1 + prefix2
    object = client.list_objects_v2({bucket: bucket,
                                     prefix: prefix,
                                     max_keys: 100})
    files = []
    object.contents.each do |c|
      files << c.key
    end

    files
  end
end
