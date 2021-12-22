class CertifyHelpPreview < ActionMailer::Preview

    def send_email
        # @help_request = params[:request]
        @help_request = {
            "first_name"=>"Bryan",
            "last_name"=>"Tanifum",
            "email"=>"btanifum@oasysic.com",
            "duns"=>"27746632", 
            "certify_email"=>"btanifum2@oasysic.com", 
            "sam_active"=>"Active", 
            "program"=>"Disaster Relief", 
            "issue"=>"Contributor/Spouse Account", 
            "issue_description"=>"Here is a description of the issue I am facing... \r\nPlease help!"
        }
        CertifyHelpMailer.send_email(@help_request)
    end

end
