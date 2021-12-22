task :create_version do
  desc "create VERSION.  Use MAJOR_VERSION, MINOR_VERSION, PATCH_VERSION, BUILD_VERSION to override defaults"

  version_file = "#{Rails.root}/config/initializers/version.rb"
  major = ENV["MAJOR_VERSION"] || 2
  minor = ENV["MINOR_VERSION"] || 1
  patch = ENV["PATCH_VERSION"] || 2
  build = ENV["BUILD_VERSION"] || `date +%s`
  version_string = "Rails.application.config.version = #{[major.to_s, minor.to_s, patch.to_s, build.strip]}\n"
  File.open(version_file, "w") {|f| f.print(version_string)}
  $stderr.print(version_string)
end
