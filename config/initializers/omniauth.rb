if !Feature.active?(:idp)
  require 'omniauth'

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :saml,
             :assertion_consumer_service_url => ENV["CERTIFY_SBA_SAML_CALLBACK_URL"],
             :issuer => ENV["SBA_ISSUER"],
             :idp_sso_target_url => ENV["MAX_SAML_URL"],
             :request_attributes => [
                 {name: 'maxEmail', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'MAX.gov-registered email address'},
                 {name: 'maxFirstName', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'First Name'},
                 {name: 'maxLastName', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Last Name'},
                 {name: 'maxOrgTag', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'Users Organization'},
                 {name: 'maxUserClassification', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'User Classification'},
                 {name: 'maxGroupList', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'MAX.gov Group List'},
                 {name: 'maxId', name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic', friendly_name: 'MAX.gov User ID'}
             ],
             :attribute_statements => [
                 {:email => ['maxEmail']},
                 {:first_name => ['maxFirstName']},
                 {:last_name => ['maxLastName']},
                 {:org => ['maxOrgTag']},
                 {:classification => ['maxUserClassification']},
                 {:groups => ['maxGroupList']},
                 {:maxId => ['maxId']}
             ],
             :attribute_service_name => "Max.gov attributes",
             :authn_context => ENV["MAX_ASSERTION_LEVEL"],
             :idp_cert => ENV["MAX_GOV_CERT"]
  end
end