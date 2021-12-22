# CarrierWave.configure do |config|
#   config.fog_provider = "fog/aws"          # required
#   config.fog_credentials = {
#     provider: "AWS",                       # required
#     aws_access_key_id: ENV["S3_PUBLIC_ACCESS_KEY"],            # required unless using use_iam_profile
#     aws_secret_access_key: ENV["S3_PUBLIC_SECRET_KEY"],        # required unless using use_iam_profile
#     use_iam_profile: false,                 # optional, defaults to false
#     region: "us-east-1",                   # optional, defaults to 'us-east-1'
#   # host: "s3.example.com",                # optional, defaults to nil
#   # endpoint: "https://s3.example.com:8080", # optional, defaults to nil
#   }
#   config.fog_directory = "vol-suspensions-bucket"                                      # required
#   # config.fog_public = false                                                 # optional, defaults to true
#   # config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
# end
