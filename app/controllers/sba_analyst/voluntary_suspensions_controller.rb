module SbaAnalyst
  class VoluntarySuspensionsController < SbaAnalystController
    def show
      voluntary_suspension
    end

    def update
      voluntary_suspension.send("#{params[:review_action]}!", current_user)
      redirect_to [:sba_analyst, voluntary_suspension]
    end

    def pdf
      pdf_filename = File.join(Rails.root, "tmp/my_document.pdf")
      send_file(pdf_filename, :filename => "your_document.pdf", :type => "application/pdf")
    end

    private

    def voluntary_suspension
      @voluntary_suspension ||= VoluntarySuspension.find(params[:id])
    end
  end
end
