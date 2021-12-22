SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{13.months.to_i}; includeSubDomains" # 33696000
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.csp = {
      # "meta" values. these will shaped the header, but the values are not included in the header.
      report_only:  false,     # default: false
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

      # directive values: these values will directly translate into source directives
      default_src: %w(https: 'self' *.cloudflare.com *.atlassian.net),
      # # frame_src: %w('self' *.google.com *.google-analytics.com *.googletagmanager.com *.atlassian.net),
      connect_src: %w(wws: https: 'self' data: *.google.com),
      font_src: %w('self' data:),
      img_src: %w(blob: https: 'self' *.google-analytics.com data:),
      media_src: %w('self'),
      object_src: %w('self' data:),
      script_src: %w('self' 'unsafe-eval' 'unsafe-inline' *.newrelic.com *.nr-data.net *.google.com *.digitalgov.gov *.google-analytics.com *.gstatic.com *.cloudflare.com *.googletagmanager.com *.atlassian.net),
      style_src: %w('self' 'unsafe-inline'),
      base_uri: %w('self'),
      child_src: %w('self' *.google.com *.google-analytics.com *.googletagmanager.com *.atlassian.net),
      form_action: %w('self' *.max.gov),
      frame_ancestors: %w('self'), # this is allowed to accomodate the iframe for ckeditor US867
      plugin_types: %w(application/x-shockwave-flash application/pdf),
      block_all_mixed_content: true, # see [http://www.w3.org/TR/mixed-content/](http://www.w3.org/TR/mixed-content/)
      upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
      #report_uri: %w(https://report-uri.io/example-csp)
  }

end
