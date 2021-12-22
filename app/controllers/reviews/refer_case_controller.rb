module Reviews
  class ReferCaseController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :set_office, :set_individual, :add_a_note, :review, :finish

    def show
      @offices = Program.find_by(name: 'eight_a').business_units.reject {|biz| biz.users.empty? || excluded_offices.include?(biz.name)}
      @referral = Referral.new
      @office_users = office_users if step == :set_individual
      render_wizard
    end

    def update
      @referral = Referral.new(referral_params)
      case step
        when :add_a_note
          session[:refer_subject] = params[:note_subject]
          session[:refer_message] = params[:note_message]
          session[:refer_tags] = params[:note_tags]
        when :review
          note = Note.create!(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: session[:refer_subject], body: session[:refer_message], author_id: current_user.id, published: true, tags: session[:refer_tags])
          ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, note.id)
          session.delete(:refer_subject)
          session.delete(:refer_message)
          session.delete(:refer_tags)
          @review.refer_to_new_reviewer(@referral.individual, @referral.office)
          ApplicationController.helpers.log_activity_application_event('reviewer_changed', @sba_application.id, current_user.id, @referral.individual.id)
          referral_notification
        when :finish
      end
      redirect_to wizard_path(@next_step, referral: {office_id: @referral.office_id, individual_id: @referral.individual_id})
    end

    private

    def office_users
      return firm_district_office_users if office_name == "DISTRICT_OFFICE"
      role_office_users
    end

    def invalid_note_params?
      params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
    end

    def referral_params
      params.require(:referral).permit(:office_id, :individual_id)
    end

    def office_name
      Referral.new(referral_params).office.name
    end

    def excluded_offices
      return %w(AREA_OFFICE) if @review.type == 'Review::AdverseAction'
      %w(DISTRICT_OFFICE AREA_OFFICE)
    end

    def firm_district_office_users
      return role_office_users unless cert_duty_station_id
      User.where("users.roles_map::text LIKE '%DISTRICT_OFFICE%8a%'").where(id: duty_station_users(cert_duty_station_id))
    end

    def role_office_users
      User.where("users.roles_map::text LIKE ?", "%#{office_name}%8a%")
    end

    def duty_station_users(duty_station_id)
      Office.where(duty_station_id: duty_station_id).pluck(:user_id)
    end

    def cert_duty_station_id
      original_cert&.duty_station&.id
    end

    def original_cert
      @organization.certificates.eight_a.first
    end

    def referral_notification
      subtype = ""
      business_name = ""
      if @referral.office.name == "CODS"
        subtype = "assigned"
      else
        subtype = "review"
        business_name = @sba_application.organization.name
      end

      if @sba_application.is_really_a_review?
        send_notification_to_refered("8(a)", master_application_type(@sba_application), subtype, @referral.individual.id, nil, @referral.individual.email, business_name, @sba_application.case_number)
      else
        send_notification_to_refered("8(a)", master_application_type(@sba_application), subtype, @referral.individual.id, @sba_application.id, @referral.individual.email, business_name)
      end
    end
  end
end
