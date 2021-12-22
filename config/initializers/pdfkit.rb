PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bundle/bin/wkhtmltopdf' if %w(development).include? Rails.env
  config.default_options = {
      :page_size => 'A4',
      :print_media_type => true
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = "http://127.0.0.1:3000"
  # Modify asset host config setting in `config/application.rb`
  # Or create a new initializer: `config/initializers/wkhtmltopdf.rb`
end


# /System/Volumes/Data/Users/ngwa/.rvm/gems/ruby-2.4.9@sba-one-app/wrappers/wkhtmltopdf