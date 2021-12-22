class Users::PasswordsController < Devise::PasswordsController

  before_action   :set_public_flag

  include DeviseHelper

  protect_from_forgery with: :exception

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      session[:email] = params[:user][:email]
      flash.clear
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash.now[:error] = devise_error_messages!
      respond_with(resource, location: new_user_password_path )
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:info, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:info, :updated_not_active)
      end

      flash.clear
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      flash.now[:error] = devise_error_messages!
      respond_with resource
    end
  end

  def reset_password_instructions_confirmation
  end

  def reset_password_confirmation
  end

  def is_strong
  rescue ActionController::InvalidAuthenticityToken => e
    logger.warn("Another PasswordsController#is_strong invalid authenticity error: #{e}")
  end

  def strength
  rescue ActionController::InvalidAuthenticityToken => e
    logger.warn("Another PasswordsController#strength invalid authenticity error: #{e}")
  end

  protected
  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : reset_password_confirmation_path
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    reset_password_instructions_confirmation_path
  end

  def set_public_flag
    @public = true
  end

end
