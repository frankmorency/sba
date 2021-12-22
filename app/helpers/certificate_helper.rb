module CertificateHelper
  def certificate_title_link(cert, user, org)
    if wosb_or_mpp_with_perms(user, cert)
      link_to cert.title, new_wosb_mpp_cert_review(cert)
    elsif cert.is_8a?
      path = sba_application_application_dashboard_overview_index_path(sba_application_id: cert.dashboard_display_app.id)

      if cert.doc_upload?
        if user.is_vendor?
          app = cert.dashboard_display_app || cert.current_application
          path = (app.try(:current_user) == user) ? sba_application_path(cert.dashboard_display_app) : nil
        else
          path = sba_application_path(cert.dashboard_display_app, organization_id: cert.organization.id)
        end
      end

      if path
        link_to cert.title, path
      else
        cert.title
      end
    elsif user.can_view_app?(cert) || user.can?(:ensure_vendor) && !cert.is_8a? && current_user.can_view_answers?(cert.dashboard_display_app)
      link_to cert.title, app_read_only_path(cert.dashboard_display_app || cert.current_application, org)
    else
      cert.title
    end
  end

  def certificate_review_link(certificate, current_user)
    if wosb_or_mpp_with_perms(current_user, certificate)
      link_to certificate.certificate_type.initial_questionnaire.link_label, new_sba_analyst_sba_application_review_path(certificate.current_application)
    else
      certificate.certificate_type.initial_questionnaire.link_label
    end
  end

  def certificate_action_links(cert, user)
    html = ""
    if cert.current_application.can_be_returned?
      if user.can_review? cert
        html << "<br/>"
        html << link_to("Return to Vendor", return_for_modification_sba_analyst_sba_application_dashboard_index_path(cert
          .current_application.id))

        if cert.current_application.zip_file_status >= 2 || (cert.current_application.zip_file_status == 1 && cert.current_application.zip_file_exists?)
          html << "<br/>"
          html << link_to("Download Zip", download_zip_sba_analyst_sba_application_dashboard_index_path(cert.current_application.id), target: "_blank")
        elsif cert.current_application.zip_file_status == 0
          html << "<br/>"
          html << link_to("Generate Zip", generate_zip_sba_analyst_sba_application_dashboard_index_path(cert.current_application.id))
        end
      end
    end

    if user.can?(:ensure_ops_support) && cert.is_8a?
      html << link_to("Annual Review", create_8a_annual_review_sba_analyst_sba_application_dashboard_index_path(cert.current_application.id))
    end

    html.html_safe
  end

  def certificate_annual_review_links(cert, user, ar_text = "New Annual Report")
    html = ""
    if cert.renewable? user
      html << link_to("Renew", new_certificate_type_application_type_sba_application_path(cert.certificate_type, SbaApplication::ANNUAL_REVIEW) + "?original_certificate_id=#{cert.id}")
    end

    if cert.needs_annual_report? user
      html << link_to(ar_text, new_certificate_type_application_type_sba_application_path(cert.certificate_type, SbaApplication::ANNUAL_REVIEW) + "?original_certificate_id=#{cert.id}")
    end

    html.html_safe
  end

  def certificate_summary_link(cert, org)
    link_to "View summary", questionnaire_organization_sba_application_path((cert.initial_app || cert.current_application).questionnaire, org.id, (cert.initial_app || cert.current_application).id) unless cert.is_8a?
  end

  def cert_reconsideration_actions(certificate)
    app = certificate.initial_app
    review = app.current_review
    reconsider_section = app.last_reconsideration_section
    sub_app = reconsider_section.sub_application

    return "" if app.submitted_reconsideration?
    return sub_application_edit_link reconsider_section if sub_app.submitted? && !app.submitted? && !current_user.is_sba?

    if !review
      link_to reconsider_section.title, questionnaire_organization_sba_application_path(sub_app.questionnaire.name, certificate.current_application.organization, sub_app.id)
    elsif app.current_review.pending_reconsideration_or_appeal?
      if current_user.is_sba?
        "Pending Appeal"
      else
        link_to "Pending Appeal", appeal_or_reconsideration_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(app, sub_app)
      end
    # elsif review.pending_reconsideration?
    #   sub_application_edit_link reconsider_section
    # elsif review.reconsideration?
    #   if current_user.is_sba?
    #     reconsider_section.title
    #   else
    #     link_to reconsider_section.title, questionnaire_organization_sba_application_path(sub_app.questionnaire.name, app.organization, sub_app.id)
    #   end
    elsif review.appeal_intent?
      link_to "Intent to Appeal", appeal_reminder_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(app, sub_app)
    elsif review.appeal?
      "Appeal"
    else
      # link_to reconsider_section.title, questionnaire_organization_sba_application_path(sub_app.questionnaire.name, app.organization, sub_app.id)
    end
  end

  def wosb_or_mpp_with_perms(user, cert)
    wosb_user_and_cert(user, cert) || mpp_user_and_cert(user, cert) && user.can_review_wosb_mpp?
  end

  def wosb_or_mpp_without_perms(user, cert)
    wosb_user_and_cert(user, cert) || mpp_user_and_cert(user, cert) && !user.can_review_wosb_mpp?
  end

  def wosb_user_and_cert(user, cert)
    user.can?(:ensure_wosb_user) && %w(wosb edwosb).include?(cert.certificate_type.name)
  end

  def mpp_user_and_cert(user, cert)
    user.can?(:ensure_mpp_user) && cert.certificate_type.name == "mpp"
  end

  def new_wosb_mpp_cert_review(cert)
    new_sba_analyst_sba_application_review_path(cert.initial_app)
  end
end
