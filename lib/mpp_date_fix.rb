require 'ap';
require 'csv';

class MppDateFix

  def process_csv(csv_file_path)
    # 'lib/mpp_aug_4_2017.csv'
    # =TEXT(A1, "yyyy-mm-dd")
    CSV.read(csv_file_path).each do |row|
     back_date_certificates row[1], row[2]
    end
  end

  def back_date_certificates(duns, date_str)

    puts "========================================================="
    puts "Processing DUNS - #{duns}. New Issue Date - #{date_str}"

    #format_str = "%m/%d/%Y"
    three_years = 365 * 3
    #Date.strptime(date_str, format_str)
    date = Date.parse(date_str)
    org = Organization.find_by_duns_number duns
    cert = org.certificates.find_by_type 'Certificate::Mpp'
    if cert
      puts "Certificate State - #{cert.workflow_state}"
    else
      puts "No MPP Certificate found"
    end

    if cert && cert.workflow_state == "active"
      puts "Certificate before changes"
      puts "Issue Date - #{cert.issue_date}, expiry_date - #{cert.expiry_date}, next_annual_report_date - #{cert.next_annual_report_date}, created_at - #{cert.created_at}"

      # Set Issue date, expiry date, next annual report date and created date on Cert
      cert.issue_date = date
      cert.expiry_date = cert.issue_date + three_years.days
      cert.next_annual_report_date = cert.issue_date + 365.days
      cert.created_at = date
      cert.save!

      cert = org.certificates.find_by_type 'Certificate::Mpp'
      puts "Certificate after changes"
      puts "Issue Date - #{cert.issue_date}, expiry_date - #{cert.expiry_date}, next_annual_report_date - #{cert.next_annual_report_date}, created_at - #{cert.created_at}"

      # Set submitted date
      app = cert.sba_application
      puts "Application before changes"
      puts "application_submitted_at #{app.application_submitted_at}"

      app.application_submitted_at = cert.issue_date
      app.save!

      app = cert.sba_application

      puts "Application after changes"
      puts "application_submitted_at #{app.application_submitted_at}"
    else
      puts "Non Active Certificate found"
    end

    puts "========================================================="
    puts ""
  end

end
