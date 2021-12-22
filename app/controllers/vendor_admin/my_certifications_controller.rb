module VendorAdmin
  class MyCertificationsController < VendorAdminController
    before_action :set_current_organization
    before_action :set_certificates

    def index
      @certificate_type_ids = current_organization.available_programs

      # TODO: may be this should reside in some other places but not here?
      @requirements_maps = {
        'wosb' => 'Woman Owned Small Business (WOSB) Program <a href="../prepare#wosb-anc" target = "_blank">(Review requirements)</a>'.html_safe,
        'edwosb' => 'Economically Disadvantaged Woman Owned Small Business (EDWOSB) Program <a href="../prepare#edwosb-anc" target="_blank">(Review requirements)</a>'.html_safe,
        'mpp' => 'All Small Mentor-Protégé Program <a href="../prepare#mpp-anc" target="_blank">(Review requirements)</a>'.html_safe,
        'eight_a' => CertificateType.find_by(name: 'eight_a').initial_questionnaire.link_label.html_safe
       }
    end
  end
end
