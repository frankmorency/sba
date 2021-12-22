class VendorAdminMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def notify_vs_approved(organization)
    @name = "#{organization.govt_bus_poc_last_name}, #{organization.govt_bus_poc_first_name}"
    recipient = "#{@name} <#{organization.govt_bus_poc_email}>"
    mail(to: recipient, subject: 'Your application for a voluntary suspension at the SBA has been approved')
  end

  def notify_vs_rejected(organization)
    @name = "#{organization.govt_bus_poc_last_name}, #{organization.govt_bus_poc_first_name}"
    recipient = "#{@name} <#{organization.govt_bus_poc_email}>"
    mail(to: recipient, subject: 'Your application for a voluntary suspension at the SBA has been rejected')
  end

end
