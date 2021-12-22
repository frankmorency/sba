module VendorAdmin::ApplicationDashboardHelper

  def application_status(app, review = nil)
    status = ''
    if review
      status = status + dashboard_review_status(@review)
      if app.submitted_reconsideration?
        status = status + " (Reconsideration)"
      end
    elsif app&.certificate&.workflow_state == 'bdmis_rejected'
      status = status + 'BDMIS Rejected'
    else
      status = status + app.workflow_state.try(:humanize)
    end
    status
  end

  def display_create_app_link?(result_set)
    return true if result_set.empty?
    return true if all_certs_closed?(result_set)
    false
  end

  def certificate_not_present?(program)
    current_organization.displayable_certificates.joins(:certificate_type)
                        .where('certificate_types.name = ?', program)
                        .map { |cert| ProgramParticipation::CertificateResult.new(cert) }
                        .blank?
  end

  def all_certs_closed?(result_set)
    total_cert_count = result_set.organization.certificates.joins(:certificate_type)
                             .where('certificate_types.name = ?', result_set.program.name).count
    closed_cert_count = result_set.organization.certificates.joins(:certificate_type)
                            .where('certificate_types.name = ?', result_set.program.name)
                            .where(workflow_state: ['closed','bdmis_rejected']).count
    # Return false if all certificates are not closed.  
    return false if total_cert_count != closed_cert_count
    # Return false if there are un-submitted applications
    return false if total_cert_count != result_set.applications.count
    true
  end

  def all_certs_soft_deleted?(result_set)
    total_cert_count = result_set.organization.certificates.joins(:certificate_type)
                                 .where('certificate_types.name = ?', result_set.program.name).count
    deleted_cert_count = result_set.organization.certificates.joins(:certificate_type)
                                   .where('certificate_types.deleted_at is not null').count
    return total_cert_count == deleted_cert_count
  end

  def vendor_contributor_section_display sba_application, section
    if sba_application.is_under_reconsideration?
      sub_application_answer_content_link section
    else
      link_to section.title, edit_sba_application_questionnaire_contributor_section_path(sba_application, sba_application.questionnaire, section)
    end
  end

  def vendor_reconsideration_section_display sba_application, section
    sub_app = section.sub_application

    if sba_application.submitted? && sub_app
      if sub_app.submitted?
        sub_application_answer_content_link section
      else
        if sub_app.reconsideration_or_appeal_deadline_passed?
          render partial: 'vendor_admin/application_dashboard/overview/appeal_or_reconsideration_deadline_past', locals: {title: "Appeal"}
        else
          link_to "Appeal", intend_to_appeal_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(sba_application, {sub_application_id: sub_app.id})
        end
      end
    else
      if section.is_last?
        if sub_app.reconsideration_or_appeal_deadline_passed?
          render partial: 'vendor_admin/application_dashboard/overview/appeal_or_reconsideration_deadline_past', locals: {title: section.title}
        elsif sub_app.submitted?
          sub_application_edit_link section
        else
          if sba_application.current_review
            if sba_application.current_review.pending_reconsideration_or_appeal?
              link_to "Appeal", intend_to_appeal_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(sba_application, sub_app)
            elsif sba_application.current_review.pending_reconsideration?
              sub_application_edit_link section
            elsif sba_application.current_review.reconsideration?
              sub_application_answer_content_link section
            elsif sba_application.current_review.appeal_intent?
              link_to 'Intent to Appeal', appeal_reminder_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(sba_application, sub_app)
            elsif sba_application.current_review.appeal?
              'Appeal'
            else
              sub_application_answer_content_link section
            end
          else
            sub_application_answer_content_link section
          end
        end
      else
        sub_application_answer_content_link section
      end
    end
  end

end
