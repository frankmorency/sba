class RESTEndpointPage1 < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_1@mailinator.com')
  sleep 10
end

class RESTEndpointPage2 < GenericBasePage
  include DataHelper

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_2@mailinator.com')
  sleep 10
end

class RESTEndpointPage3 < GenericBasePage
  include DataHelper

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_3@mailinator.com')
  sleep 10
end
class RESTEndpointPage4 < GenericBasePage
  include DataHelper

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_A1@mailinator.com')
  sleep 10
end

class RESTEndpointPage5 < GenericBasePage
  include DataHelper

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_A2@mailinator.com')
  sleep 10
end

class RESTEndpointPage6 < GenericBasePage
  include DataHelper

  $config_file1 = Dir.pwd + "/features/support"
  config_rest = YAML.load(File.read($config_file1 + "/config.yaml"))
  rest_admin_endpoint_url = config_rest['rest_admin_url']
  page_url rest_admin_endpoint_url.concat('contributor_B2@mailinator.com')
  sleep 10
end