namespace :certificate do
  task wosb_expiry_email_reminder: :environment do
    #Todo - Check if Job has already run for the day and exit
    @cron_status = CronJobHistory.new
    @cron_status.start_time = Time.new
    @cron_status.type = "certificate:wosb_expiry_email_reminder"
    @cron_status.save!

    cert_types = ['wosb', 'edwosb']
    forty_five_days = Date.today + 45.days
    certs_expiring_in_45 = Certificate.get_certificates_expiring_on(cert_types, forty_five_days)
    Certificate.process_email(certs_expiring_in_45, 45, forty_five_days)

    thirty_days = Date.today + 30.days
    certs_expiring_in_30 = Certificate.get_certificates_expiring_on(cert_types, thirty_days)
    Certificate.process_email(certs_expiring_in_30, 30, thirty_days)

    fifteen_days = Date.today + 15.days
    certs_expiring_in_15 = Certificate.get_certificates_expiring_on(cert_types, fifteen_days)
    Certificate.process_email(certs_expiring_in_15, 15, fifteen_days)

    one_day = Date.today + 1.days
    certs_expiring_in_1 = Certificate.get_certificates_expiring_on(cert_types, one_day)
    Certificate.process_email(certs_expiring_in_1, 1, one_day)

    @cron_status.end_time = Time.new
    @cron_status.save!
  end

  task mpp_expiry_email_reminder: :environment do
    #Todo - Check if Job has already run for the day and exit
    @cron_status = CronJobHistory.new
    @cron_status.start_time = Time.new
    @cron_status.type = "certificate:mpp_expiry_email_reminder"
    @cron_status.save!

    cert_types = ['mpp']
    sixty_days = Date.today + 60.days
    certs_expiring_in_60 = Certificate.get_certificates_with_annual_review_due(cert_types, sixty_days)
    Certificate.process_email(certs_expiring_in_60, 60, sixty_days)

    forty_five_days = Date.today + 45.days
    certs_expiring_in_45 = Certificate.get_certificates_with_annual_review_due(cert_types, forty_five_days)
    Certificate.process_email(certs_expiring_in_45, 45, forty_five_days)

    thirty_days = Date.today + 30.days
    certs_expiring_in_30 = Certificate.get_certificates_with_annual_review_due(cert_types, thirty_days)
    Certificate.process_email(certs_expiring_in_30, 30, thirty_days)

    # This is currently only used by mpp
    one_day_passed = Date.today - 1.days
    certs_has_expired_by_1 = Certificate.get_certificates_with_annual_review_due(cert_types, one_day_passed)
    Certificate.process_email(certs_has_expired_by_1, -1, one_day_passed)

    @cron_status.end_time = Time.new
    @cron_status.save!
  end

  task expire: :environment do
    @cron_status = CronJobHistory.new
    @cron_status.start_time = Time.new
    @cron_status.type = "certificate:expire"
    @cron_status.save!
    Certificate.mark_certificates_as_expired
    @cron_status.end_time = Time.new
    @cron_status.save!
  end
end