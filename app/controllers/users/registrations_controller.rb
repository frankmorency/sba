
class Users::RegistrationsController < Devise::RegistrationsController

  before_action   :set_public_flag

  include DeviseHelper

  skip_before_filter :verify_authenticity_token, only: :create

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up
  def new
    reset_session
    build_resource({})
    yield resource if block_given?
    respond_with self.resource
  end

  def step2
    if step_1_registration_valid?(step_1_registration_params)
      session[:first_name] = params[:user][:first_name]
      session[:last_name] = params[:user][:last_name]
      session[:email] = params[:user][:email]
      render :step2
    else
      render :new
    end
  end

  # POST /resource
  def create
    if true
      if step_2_registration_valid?(params[:user][:password], params[:user][:password_confirmation], params[:thischeckbox])
        build_resource(sign_up_params.merge({first_name: session[:first_name]}).merge({email: session[:email]}).merge({last_name: session[:last_name]}))
        resource.skip_confirmation! if Rails.env.development? # AC: added this to bypass 503 auth error on development
        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message :info, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message :info, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            reset_session
            flash.clear
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          redirect_to new_user_registration_path
        end
      else
        render :step2
      end
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      set_minimum_password_length
      flash.now[:error] = 'There was an error with the recaptcha code below. Please re-enter the code.'
      flash.delete :recaptcha_error
      render :step2
    end
  end

  # GET /resource/edit
  def edit
    @public = false
    @edit_profile = true if request.env['REQUEST_PATH'].split('/').include?('edit_profile')
    render :edit
  end

  # PUT /resource
  def update
    @public = false
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    ## Needed so a Contirubor and a Vendor Admin can update their profile and password
    ## Yes both blocks are identical
    if org_duns_mpin.present?
      if is_vendor_admin(@current_user) && org_duns_mpin == params[:mpin]
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          resource_updated = resource.update_without_password(update_without_password_params)
        else
          resource_updated = update_resource(resource, account_update_params)
        end
      end
      if !is_vendor_admin(@current_user)
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          resource_updated = resource.update_without_password(update_without_password_params)
        else
          resource_updated = update_resource(resource, account_update_params)
        end
      end
    end

    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
        :update_needs_confirmation : :updated
        set_flash_message :info, flash_key
      end
      sign_in resource_name, resource, bypass: true    
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      if is_vendor_admin(@current_user) && org_duns_mpin != params[:mpin]
        flash[:error] = "Incorrect MPIN"
      else
        flash[:error] = devise_error_messages!
      end
      @edit_profile = true if request.referrer.split('/').include?('edit_profile')
      redirect_to :back
    end
  end
  
  def org_duns_mpin
    if is_vendor_admin(@current_user)
      org_duns = MvwSamOrganization.find_by(duns: params[:hidden_duns]).mpin
    else
      org_duns = !is_vendor_admin(@current_user)
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :info, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    reset_session
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  def update_without_password(params, *options)
    params.delete(:email)
    super(params)
  end

  def update_without_password_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :email)
  end

  protected

  def step_1_registration_params
    params.require(:user).permit(:first_name, :last_name, :email, :confirm_email)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :attribute
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    vendor_admin_dashboard_index_path
  end

  # The path used after resource update.
  def after_update_path_for(resource)
    vendor_admin_my_profile_index_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    registration_confirmation_path(resource)
  end

  def step_1_registration_valid? params
    flash.now[:error] = 'First name is required.' if params[:first_name].blank?
    flash.now[:error] = 'Last name is required.' if params[:last_name].blank?
    flash.now[:error] = 'An account already exists for this email. Please login or reset the password.' if User.find_by email: params[:email]
    flash.now[:error] = 'Email is required.' if params[:email].blank?
    flash.now[:error] = 'Enter a valid email address.' unless params[:email] =~ /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
    flash.now[:error] = 'Email confirmation is required.' if params[:confirm_email].blank?
    flash.now[:error] = 'Enter a valid email address.' unless params[:confirm_email] =~ /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
    flash.now[:error] = 'Email and email confirmation must match.' if params[:email] != params[:confirm_email]


    if flash[:error]
      false
    else
      true
    end
  end

  def step_2_registration_valid? password, password_confirmation, checkbox
    flash.now[:error] = 'Password is required.' if password.blank?
    # flash.now[:error] = 'Password must be strong.' unless ['strong'].include?(User.get_password_strength(password))
    flash.now[:error] = 'Password confirmation is required.' if password_confirmation.blank?
    flash.now[:error] = 'Password and Password confirmation must match.' if password != password_confirmation
    flash.now[:error] = "I accept' check box must be checked." if checkbox.blank?
    flash.now[:error] = "Complexity requirement not met. Length should be 12-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character" if password !~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!=@$%^&*-]).{12,70}$/



    if flash[:error]
      false
    else
      true
    end
  end

  def set_public_flag
    @public = true
  end

  def is_vendor_admin(user)
    user.roles_map["Legacy"]["VENDOR"][0] == "admin"
  end
end
