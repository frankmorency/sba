class AnnualReview8aReminderMailer < ApplicationMailer
  layout 'layouts/email'

  def first_reminder(org, anniversary_date, cc_email = nil)
    @org_name = org.name
    if org.default_user
      @vendor_admin_name = org.default_user&.name
      @email = org.default_user.email
    else
      @vendor_admin_name = org&.govt_bus_poc_first_name + ' ' + org&.govt_bus_poc_last_name
      @email = org&.govt_bus_poc_email
    end
    @anniversary_date_formatted = anniversary_date_adjusted(anniversary_date).strftime("%m/%d/%Y")
    @due_date = anniversary_date_adjusted(anniversary_date) + 30.days
    @due_date_formatted = @due_date.strftime("%m/%d/%Y")
    @subject = "Your 8(a) Annual Review is due in Certify on #{@due_date_formatted}."
    mail(to: @email, cc: cc_email, subject: @subject, template_path: 'mail/annual_review_8a')
  end

  def second_reminder(org, anniversary_date, cc_email = nil)
    @org_name = org.name
    if org.default_user
      @vendor_admin_name = org.default_user&.name
      @email = org.default_user.email
    else
      @vendor_admin_name = org&.govt_bus_poc_first_name + ' ' + org&.govt_bus_poc_last_name
      @email = org&.govt_bus_poc_email
    end
    @anniversary_date_formatted = anniversary_date_adjusted(anniversary_date).strftime("%m/%d/%Y")
    @due_date = anniversary_date_adjusted(anniversary_date) + 30.days
    @due_date_formatted = @due_date.strftime("%m/%d/%Y")
    @subject = "Your 8(a) Annual Review is due in Certify on #{@due_date_formatted}."
    mail(to: @email, cc: cc_email, subject: @subject, template_path: 'mail/annual_review_8a')
  end

  def ar_for_duns(org, anniversary_date, cc_email = nil)
    @duns_number = org.duns_number
    @from_email = ENV["EMAIL_FROM_ADDRESS"] || 'noreply@mailinator.com'
    @org_name = org.name
    if org.default_user
      @vendor_admin_name = org.default_user&.name
      @email = org.default_user.email
    else
      @vendor_admin_name = org&.govt_bus_poc_first_name + ' ' + org&.govt_bus_poc_last_name
      @email = org&.govt_bus_poc_email
    end
    
    @anniversary_date_formatted = anniversary_date_adjusted(anniversary_date).strftime("%m/%d/%Y")
    @due_date = anniversary_date_adjusted(anniversary_date) + 30.days
    @due_date_formatted = @due_date.strftime("%m/%d/%Y")
    @subject = "Your 8(a) Annual Review is due in Certify on #{@due_date_formatted}."
    mail(from: @from_email, to: @email, cc: cc_email, subject: @subject, template_path: 'mail/annual_review_8a', template_name: 'ar_for_duns')
  end

  private

  # if running in December, then return anniversary_date for next year
  def anniversary_date_adjusted(anniversary_date)
    return anniversary_date unless Date.today.month == 12
    return anniversary_date unless anniversary_date.month == 1
    return anniversary_date unless anniversary_date.year == Date.today.year
    anniversary_date + 1.year
  end
end