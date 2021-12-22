class CustomFailure < Devise::FailureApp
  def redirect
    store_location!
    if is_flashing_format?
      if flash[:timedout] && flash[:alert]
        flash.keep(:timedout)
        flash.keep(:alert)
      else
        if %w(unconfirmed).include?(warden_message.to_s)
          flash[:info] = i18n_message
          session[:flash_title] = 'Verify Your Account'
        else
          flash[:alert] = i18n_message
        end

      end
    end
    redirect_to redirect_url
  end


  protected

  def i18n_message(default = nil)
    message = warden_message || default || :unauthenticated

    if message.is_a?(Symbol)
      options = {}
      options[:resource_name] = scope
      options[:scope] = "devise.failure"
      options[:default] = [message]
      auth_keys = scope_class.authentication_keys
      keys = (auth_keys.respond_to?(:keys) ? auth_keys.keys : auth_keys).map { |key| scope_class.human_attribute_name(key) }
      options[:authentication_keys] = keys.join(I18n.translate(:"support.array.words_connector"))
      options[:email] = params[:user][:email] if %w(unconfirmed).include?(warden_message.to_s)
      options = i18n_options(options)

      I18n.t(:"#{scope}.#{message}", options)
    else
      message.to_s
    end
  end

end