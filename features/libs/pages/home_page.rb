class HomePage < GenericBasePage

  $config_file = Dir.pwd + "/features/support"
  config_data = YAML.load(File.read($config_file+"/config.yaml"))
  page_url config_data['web_url']
  #puts config_data['web_url']
  element(:sign_in) {|b| b.button(:class => "button-full".split)}
  element(:get_started) {|b| b.button(:class => "usa-color-gold".split)}

end
