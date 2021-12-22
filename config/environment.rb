require File.expand_path('../application', __FILE__)

Rails.application.initialize!
ENV['TMPDIR'] = Rails.root.join('tmp').to_s
