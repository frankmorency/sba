# EIN/SSN, MPIN, Password
Rails.application.config.filter_parameters += [:password, :secret, :salt, :warden, :session, :cookie, :csrf, :mpin, :ssn_ein, :duns_number, :tax_identifier, :ssn]

Rails.application.config.filter_parameters << lambda do |param_name, value|
  if %w[value].include?(param_name)
    # Alter the string in place because we don't have access to
    # the hash to update the key's value
    value.gsub!(/ssn"?\w*:\w*"[0-9\-]+/, 'ssn":"FILTERED')
  end
end
