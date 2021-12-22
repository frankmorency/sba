class Users::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create]
  protect_from_forgery :except => :create

  before_action   :set_public_flag

  include DeviseHelper
  
  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def new_saml
    redirect_to "/users/auth/saml"
  end

  # POST /resource/sign_in
  def create
    # do not allow resticted domains to login through vendor login
    email = params.dig(:user, :email)&.downcase
    restricted_domains = ['.gov','.mil','.fed.us']
    is_restricted_domain = restricted_domains.any? { |word| email.end_with?(word) }
    is_vendor_login = request.referrer.include? '/users/sign_in'
    if is_restricted_domain && is_vendor_login
      # sign out user and re-direct to max.gov login page
      sign_out current_user
      flash[:error] = 'Please use MAX.gov to login if you are a federal employee.'
      redirect_to max_gov_path and return
    end

    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    set_up_contributor_if_needed(resource)
    
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to_on_destroy
  end

  def max_gov
  end

  if Feature.active?(:idp)
    def vendor_login_landing
    end

    def max_login_landing
    end
  end

  if Feature.active?(:idp_stubbed)
    def idp_stubbed_login_form
    end

    def idp_stubbed_login
      user = User.where("lower(email) = ?", params[:email].downcase).first

      if user
        set_session(user)
        sign_in user
        set_up_contributor_if_needed(user)
        flash[:info] = 'Logging in via IdP Subbbed Login.'
        redirect_to after_sign_in_path_for(user)
      else
        # Quick Fix. Creating a new user with first_name and last_name = id part of email.

        email = params[:email]
        id, domain = email.split('@')

        first_name = last_name = id
        password = "a long fake password"
        user = User.new({email: email, first_name: first_name, last_name: last_name, password: password})

        user_type = "Vendor"

        # Check if domain is for government user
        if ['sba.gov', '.mil', '.fed.us'].any? do |str| str.include? domain end
          user.max_id = "max_id_not_found"
          user_type = "Government"
        end

        if user.save
          flash[:info] = "User did not exist. Created a new #{user_type} user with email #{user.email}."
          redirect_to :back
        else
          flash[:error] = "User did not exit. Could not create a new user. #{user.errors.full_messages.join(",")}."
          redirect_to :back
        end
      end
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end

  def set_public_flag
    @public = true
  end

  private

  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    if all_signed_out?
      set_flash_message :info, :already_signed_out
      respond_to_on_destroy
    end
  end

end
