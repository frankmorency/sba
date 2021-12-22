class CertifyHelpController < ApplicationController
    before_action   :set_public_flag
    
    def index
    end

    def create
        @help_request = params[:request]
        puts "@help_request"
        puts "params[:request]"
        CertifyHelpMailer.send_email(@help_request).deliver
        redirect_to "/certify-help"
    end
end
