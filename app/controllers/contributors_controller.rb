class ContributorsController < ApplicationController
  before_action :set_application, except: [:reminder, :done, :reminder_complete_app]
  before_action :authenticate_user!

  before_filter :require_vendor_admin_access

  def create
    @section = @sba_application.sections.find_by(name: params[:section_id])
    pos = (@section.children.count + 1)

    u = User.find_by_email(contributor_params["email"].downcase)

    contributors = Contributor.where(:email => contributor_params["email"].downcase)

    contributor_with_application = Contributor.find_by_email_and_sba_application_id(contributor_params["email"].downcase, @sba_application.id)

    if params["contributor"]["email"].split(".")[-1]["gov"] || params["contributor"]["email"].split(".")[-1]["mil"]
      flash[:error] = "Please enter an email address that doesn't end with .gov or .mil"
      redirect_to :back
      return
    end

    # Check if the User already exists on another organization
    if u && u.organizations.present? && (u.organizations - [@sba_application.organization]).present?
      flash[:error] = "Please enter another email address for this contributor. He/She is already associated with another business in the system."
      redirect_to :back
      return
    end

    secondary_invite = false

    # Check if the Contributor already exists on..
    if contributor_with_application # current application
      flash[:error] = "Please enter another email address for this contributor. He/She has already been invited to contribute to this 8(a) application."
      redirect_to :back
      return
    elsif contributors && contributors.map(&:sba_applications).flatten.map(&:organization).include?(@sba_application.organization) # same organization, but different applications
      secondary_invite = true
    elsif contributors.present? # another organization
      flash[:error] = "Please enter another email address for this contributor. He/She has already been invited to contribute to an 8(a) application."
      redirect_to :back
      return
    end

    begin
      my_params = contributor_params.merge(section: @section, sba_application: @sba_application, position: pos, section_name_type: params[:section_id], expires_at: Time.now + 30.days)
      my_params[:email] = my_params[:email].downcase
      @contributor = Contributor.create!(my_params) # Create a new Contributor
      ApplicationController.helpers.log_activity_application_event('contributor_added', @sba_application.id, current_user.id, @contributor.id)

      if secondary_invite
        ContributorMailer.secondary_invite(@contributor.id, current_user.id).deliver
      else
        ContributorMailer.invite(@contributor.id, current_user.id).deliver
      end
      flash[:notice] = "#{contributor_params[:full_name]} has been added"
    rescue => e
      flash[:error] = "There was a problem creating or sending email to contributor"
    end

    redirect_to :back
  end

  def done
  end

  def reminder_complete_app
    begin
      @contributor = Contributor.find_by(reminder_params)
      section = @contributor.section.sba_application.sections.find_by(name: @contributor.section_name)

      if section.status == Section::IN_PROGRESS
        ContributorMailer.reminder_to_complete_app(@contributor.id, current_user.id).deliver
        flash[:notice] = "Email has been sent to your contributor"
      else
        flash[:error] = "There was a problem sending an email to your contributor"
      end
    rescue
      flash[:error] = "There was a problem sending an eamil to your contributor"
    end
    
    redirect_to :back
  end

  def reminder
    begin
      @contributor = Contributor.find_by(reminder_params)
      ContributorMailer.reminder_to_complete_app(@contributor.id, current_user.id).deliver
      flash[:notice] = "Email has been sent to your contributor"
    rescue
      flash[:error] = "There was a problem sending an email to your contributor"
    end
    redirect_to :back
  end

  def destroy
    section = @sba_application.sections.find_by(name: params[:section_id])
    contributor = @sba_application.contributors.find_by(section_id: section.id, email: params[:email])

    if contributor && contributor.revoke!(params[:id])
      ApplicationController.helpers.log_activity_application_event('contributor_removed', @sba_application.id, current_user.id, contributor.id)
      flash[:notice] = "Contributor has been removed"
    else
      flash[:notice] = "Removing contributor failed"
    end

    redirect_to :back
  end

  private

  def require_vendor_admin_access
    unless can?(:ensure_vendor, current_user) || (can? :ensure_contributor, current_user)
      user_not_authorized
    end
  end

  def contributor_params
    params.require(:contributor).permit(:full_name, :email)
  end

  def reminder_params
    params.permit(:email)
  end
end
