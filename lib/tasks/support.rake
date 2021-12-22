require 'ap'
namespace :support do
  ## Helper methods
  def save_record(model_name, verbose = true)
    if model_name.save!
      logger.ap "FYI: successfully update record"
      logger.ap model_name if verbose
    else
      logger.ap "FYI: problem updating record"
    end
  end

  desc "migrate 8a initial applications that were previously in an appeal state to the new appeal_intent"
  task :migrate_old_appeal_to_appeal_intent => [:environment, :log_to_stdout] do
    Review.where(type: "Review::EightAInitial").where(workflow_state: "appeal").each do |review|
      review.update_attribute(:workflow_state, "appeal_intent")
      review.sba_application.last_reconsideration_application.update_attribute(:workflow_state, "appeal_intent_selected")
    end
  end

  desc "set the servicing bos attribute for active certificates that do not have this already set"
  task :set_servicing_bos => [:environment, :log_to_stdout] do
    Certificate.eight_a.where(workflow_state: 'active').where(servicing_bos: nil).each do |certificate|
      annual_reviews = certificate.sba_applications.where(type: 'SbaApplication::EightAAnnualReview')
      bdmis_archives = certificate.sba_applications.where("bdmis_case_number IS NOT NULL")

      if annual_reviews.any?
        recent_ar = annual_reviews.order(created_at: :asc).last
        certificate.update(servicing_bos: recent_ar&.current_review&.case_owner)
        next
      end

      if bdmis_archives.any?
        recent_bdmis = bdmis_archives.order(created_at: :asc).last
        certificate.update(servicing_bos: recent_bdmis&.current_review&.case_owner)
      end
    end
  end

  desc "find_by_id[user_id]"
  task :find_by_id, [:user_id] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:user_id]
    Rails.logger.info "FYI: query for user with id #{param}"
    if param.present?
      users = User.where(id: param)
      ap users
    else
      ap "FYI: cound not find user with the id : #{param}"
    end
  end

  desc "find_by_email[email]"
  task :find_by_email, [:email] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:email]
    Rails.logger.info "FYI: query for user with email #{param}"
    if param.present?
      users = User.where(email: param)
      ap users
    else
      ap "FYI: could not find the user with the email '#{param}'"
    end
  end

  desc "lookup_vendor[term]"
  task :lookup_vendor, [:query] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:query]
    Rails.logger.info "FYI: query for user with search query #{param}"
    if param.present?
      users = User.vendor_user_search(param)
      if users.present?
        ap users
      else
        ap "FYI: could not find the record with this query '#{param}'"
      end
    end
  end

  desc "update_names[email:first_name:lastname]"
  task :update_names, [:query] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:query]
    if param.present?
      email, first_name, last_name = *param.split(":", 3)
      users = User.where(email: email)
      if users.present?
        user = users.first
        ap "FYI: current user record : #{user}"
        user.first_name = first_name
        user.last_name  = last_name
        save_record(user)
      else
        ap "FYI: could not find the record with this query '#{param}'"
      end
    end
  end

  desc "confirm_email[email]"
  task :confirm_email, [:query] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:query]
    if param.present?
      users = User.where(email: param)
      if users.present?
        user = users.first
        if user.confirmed_at.nil?
          user.confirmed_at = Time.now
          save_record(user)
        else
          ap "FYI: user is already confirmed at #{user.confirmed_at}"
        end
      else
        ap "FYI: could not find the record with email '#{param}'"
      end
    end
  end

  desc "reset_password[email:new_password]"
  task :reset_password, [:email_newpwd] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:email_newpwd]
    if param.present?
      email, new_password = *param.split(":", 2)
      user = User.where(email: email).first
      if user.present?
        user.reset_password(new_password, new_password)
        user.confirmed_at = Time.now
        save_record(user, false)  ## suppress the output for readability
        ap "FYI: successfully reset the password for user with email #{email}"
        ap "FYI: the password for the user is #{new_password}"
      else
        ap "FYI: could not find the record with email '#{param}'"
      end
    end
  end

  desc "lookup_sam_data[duns_number]"
  task :lookup_sam_data, [:duns_number] =>[:environment, :log_to_stdout] do |t, args|
    duns_number = args[:duns_number]
    if duns_number.present?
      sam_org =  MvwSamOrganization.find_by_duns(duns_number)
      if sam_org.present?
        ap "FYI: current data from sams.gov for DUNS: #{duns_number}"
        ap "--------------------------------------------------------"
        ap sam_org
        ap "--------------------------------------------------------"
      else
        ap "FYI: could not find record with DUNS: '#{duns_number}'"
      end
    end
  end

  desc "add_ops_support_role[email]"
  task :add_ops_support_role, [:email] =>[:environment, :log_to_stdout] do |t, args|
    email = args[:email]
    if email.present?
     user = User.where(email: email).first
     if user.present?
       ## Note: we always update the role in place!
       user.roles_map.merge!({ "Legacy" => { "SUPPORT" => ["staff"] } })
       user.save!
       Rails.logger.info "FYI: successfully update the roles for email: #{email}"
       Rails.logger.info "FYI: user roles_map: #{user.roles_map}"
     else
       Rails.logger.info "FYI: could not find the user with email: #{email}"
     end
    end
  end

  desc "add_ops_support_role[email]"
  task :add_ops_support_role, [:email] =>[:environment, :log_to_stdout] do |t, args|
    email = args[:email]
    if email.present?
     user = User.where(email: email).first
     if user.present?
       ## Note: we always update the role in place!
       user.roles_map.merge!({ "Legacy" => { "SUPPORT" => ["staff"] } })
       user.save!
       Rails.logger.info "FYI: successfully update the roles for email: #{email}"
       Rails.logger.info "FYI: user roles_map: #{user.roles_map}"
     else
       Rails.logger.info "FYI: could not find the user with email: #{email}"
     end
    end
  end

  desc "Delete 8(a) Interim submission for the given DUNS."
  task :delete_8a_interim, [:duns] =>[:environment, :log_to_stdout] do |t, args|
    duns = args[:duns]
    delete_interim_8a(duns)
  end

  desc "Daily application report"
  task :daily_application_report, [:output_file] =>[:environment, :log_to_stdout] do |t, args|
    output_file = args[:output_file]
    daily_application_report(output_file)
  end

  desc "Delete 8(a) Interim applications from a CSV file"
  task :delete_8a_interim_csv, [:csv_file_path] =>[:environment, :log_to_stdout] do |t, args|
    csv_file = args[:csv_file]
    if csv_file.present?
      business_csv = CSV.read(csv_file)
      business_csv.shift # Remove Header Row

      business_csv.each do |biz|
        duns = biz[1].strip
        if duns.present?
          duns = "0#{duns}" if duns.length == 8
          Rails.logger.info "Processing DUNS - #{duns}"
          delete_interim_8a(duns)
        end
      end
    end
  end

  desc "set the duty stations for active 8(a) certificates that do not have this already set"
  task :set_duty_stations_certificates => [:environment] do
    Certificate.eight_a.where(workflow_state: ['active', 'pending']).where(duty_station_id: nil).each do |certificate|
      initial_applications = certificate.sba_applications.where(type: 'SbaApplication::EightAMaster')
      if initial_applications.any?
        recent_app = initial_applications.order(created_at: :asc).last
        certificate.duty_station = recent_app.duty_stations.first
        certificate.save!
      end
    end
  end

  desc "Daily application report"
  task :daily_application_report, [:output_file] =>[:environment, :log_to_stdout] do |t, args|
    output_file = args[:output_file]
    daily_application_report(output_file)
  end

  desc "Record Evaluation Historiy for 8(a) Applications that were approved before feature was built. Uses a CSV"
  task :record_evaluation_history, [:csv_file_path] =>[:environment, :log_to_stdout] do |t, args|
    csv_file = args[:csv_file_path]
    if csv_file.present?
      CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |line|
        app = SbaApplication.find(line[:app_id])
        evaluator = User.find_by_email(line[:evaluator])
        eval = EvaluationHistory.new
        eval.record_evaluation_event(app, evaluator, 'determination', 'eligible')
        eval.created_at = line[:issue_date]
        eval.updated_at = line[:issue_date]
        eval.save!
        Rails.logger.info eval.id
      end
    end
  end

  desc "Create 8(a) annual reviews for a specific DUNS number"
  task :create_annual_review_for_duns, [:duns] => [:environment, :log_to_stdout] do |t, args|
    begin
      duns = args[:duns]
      program = "8(a)"
      org = Organization.find_by_duns_number duns
      if org
        app = org.create_eight_a_annual_review!

        if org.default_user
          @vendor_admin_name = org.default_user&.name
          @email = org.default_user.email
        else
          @vendor_admin_name = org&.govt_bus_poc_first_name + ' ' + org&.govt_bus_poc_last_name
          @email = org&.govt_bus_poc_email
        end
        cert = org.certificates.last
        cc_email = cert&.initial_app&.current_review&.case_owner&.email

        AnnualReview8aReminderMailer.ar_for_duns(cert.organization, app.review_for, cc_email).deliver_now if !@email.nil?

        ApplicationController.helpers.log_activity_application_event('created_system', app.id)
        Rails.logger.info "Annual Review created. Application ID - #{app.id}"
      else
        Rails.logger.info "Org not found. Duns - #{duns}"
      end
    rescue StandardError => e
      Rails.logger.error "!ERROR! - #{e}"
    end
  end

  desc "Compare 8(a) Certifications in Certify to match the information provided in OFO Data Call Spreadsheet. And log the infomratiom"
  task :compare8a_certifications_ofo_data_call, [:csv_file_path] => [:environment] do |t, args|
    begin
      Rails.logger = Logger.new("/tmp/ofo_comparison#{Time.now.to_i}.log")
      Rails.logger.info("duns,ofo_status,ofo_expiry,ofo_issue,certify_status,certify_expiry,certify_issue,status_match,issue_match,expiry_match")
      csv_file = args[:csv_file_path]
      if csv_file.present?
        CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |line|
          duns = line[:duns].to_s
          duns = "0" + duns if duns.length == 8
          duns = "00" + duns if duns.length == 7
          puts "Processing DUNS - #{duns}"
          line[:duns] = duns
          expected_status = line[:ofo_status]

          expected_expiry_date = Date.strptime(line[:ofo_expiry], "%m/%d/%Y") unless line[:ofo_expiry].nil?
          expected_issue_date = Date.strptime(line[:ofo_issue], "%m/%d/%Y") unless line[:ofo_issue].nil?
          org = Organization.find_by_duns_number duns

          if org
            eight_a = org.eight_a_certificate
            if eight_a
              certify_issue = eight_a.issue_date.to_date unless eight_a.issue_date.nil?
              certify_expiry = eight_a.expiry_date.to_date unless eight_a.expiry_date.nil?
              certify_status = eight_a.workflow_state
              status_match = (certify_status == expected_status).to_s
              issue_match = (certify_issue == expected_issue_date).to_s
              expiry_match = (certify_expiry == expected_expiry_date).to_s
              c_expiry = certify_expiry.strftime("%m/%d/%Y") unless eight_a.expiry_date.nil?
              c_issue = certify_issue.strftime("%m/%d/%Y") unless eight_a.issue_date.nil?
              if expected_expiry_date && expected_issue_date
                Rails.logger.info("#{duns},#{expected_status},#{line[:ofo_expiry]},#{line[:ofo_issue]},#{certify_status},#{c_expiry},#{c_issue},#{status_match},#{issue_match},#{expiry_match}")
              else
                Rails.logger.info("#{duns},#{expected_status},,,#{certify_status},#{c_expiry},#{c_issue},#{status_match},#{issue_match},#{expiry_match}")
              end
            end
          end
        end
      end
    rescue StandardError => e
      puts "!ERROR! - #{e}"
    end
  end

  # In - Progress
  desc "Update 8(a) Certifications in Certify to match the information provided in OFO Data Call Spreadsheet."
  task :update8a_certifications_ofo_data_call, [:csv_file_path] => [:environment] do |t, args|
    workflow_status_update_counter = 0
    issue_date_update_counter = 0
    expiry_date_update_counter = 0

    csv_report_headers = ["DUNS","BEFORE","AFTER"]
    workflow_status_report = CSV.open( "workflow_status_report.csv", 'w', :write_headers=> true, :headers => csv_report_headers )
    issue_date_report = CSV.open( "issue_date_report.csv", 'w', :write_headers=> true, :headers => csv_report_headers )
    expiry_date_report = CSV.open( "expiry_date_report.csv", 'w', :write_headers=> true, :headers => csv_report_headers )

    begin
      Rails.logger = Logger.new("/tmp/ofo_comparison#{Time.now.to_i}.log")
      Rails.logger.info("duns,ofo_status,ofo_expiry,ofo_issue,certify_status,certify_expiry,certify_issue,status_match,issue_match,expiry_match")
      csv_file = args[:csv_file_path]
      if csv_file.present?
        CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |line|
          duns = line[:duns].to_s
          duns = "0" + duns if duns.length == 8
          duns = "00" + duns if duns.length == 7
          puts "Processing DUNS - #{duns}"
          line[:duns] = duns
          expected_status = line[:ofo_status]


          expected_expiry_date = Date.strptime(line[:ofo_expiry], "%m/%d/%Y") unless line[:ofo_expiry].nil?
          expected_issue_date = Date.strptime(line[:ofo_issue], "%m/%d/%Y") unless line[:ofo_issue].nil?

          user = nil
          if Rails.env.production?
            user = User.find_by_email("van.tran@sba.gov")
          else
            user = User.first #Choose a user to fill in
          end

          org = Organization.find_by_duns_number duns

          if org
            eight_a = org.eight_a_certificate
            if eight_a
              certify_issue = eight_a.issue_date.to_date unless eight_a.issue_date.nil?
              certify_expiry = eight_a.expiry_date.to_date unless eight_a.expiry_date.nil?
              certify_status = eight_a.workflow_state
              application = eight_a.initial_app

              if expected_status == "suspended"
                puts "expected_status is #{expected_status}. Skipping."
                next
              end

              if certify_status != expected_status
                eight_a.update_attributes!(:workflow_state => expected_status)
                workflow_status_update_counter += 1
                workflow_status_report << [duns, certify_status, expected_status]
                ApplicationController.helpers.log_activity_application_certificate_event("attribute_changed", application.id, user.id, 'status' , certify_status, expected_status, "2018 OFO data-call")
              end

              # if expected_issue_date && (certify_issue != expected_issue_date)
              #   eight_a.update_attributes(:issue_date => expected_issue_date)
              #   issue_date_update_counter += 1
              #   issue_date_report << [duns, certify_issue, expected_issue_date]
              #   ApplicationController.helpers.log_activity_application_certificate_event("attribute_changed", application.id, user.id, 'program start data', certify_issue, expected_issue_date, "2018 OFO data-call")
              # end
              # 
              # if expected_expiry_date && (certify_expiry != expected_expiry_date)
              #   eight_a.update_attributes(:expiry_date => expected_expiry_date)
              #   expiry_date_update_counter += 1
              #   expiry_date_report << [duns, certify_expiry, expected_expiry_date]
              #   ApplicationController.helpers.log_activity_application_certificate_event("attribute_changed", application.id, user.id, 'program end date' , certify_expiry, expected_expiry_date, "2018 OFO data-call")
              # end
            end
          end
        end
      end
    rescue StandardError => e
      puts "!ERROR! - #{e}"
    end

    puts "workflow_status_update_counter: #{workflow_status_update_counter}\n" +
          "issue_date_update_counter: #{issue_date_update_counter}\n" +
          "expiry_date_update_counter: #{expiry_date_update_counter}"

    puts "Output reports written to #{workflow_status_report.path} \n#{issue_date_report.path} \n#{expiry_date_report.path}"
  end

end

namespace :migration_support do
  task :add_creator_to_sba_applications => [:environment, :log_to_stdout] do
    SbaApplication.all.each do |app|
      puts "Processing SbaApplication Id - #{app.id}"
      app.update_attribute(:creator_id, app.organization.try(:default_user).try(:id))
    end

    Contributor.all.each do |c|
      puts "Processing Contributor Id - #{c.id}"
      if c.sub_application
        c.sub_application.update_attribute :creator_id, c.id
      end
    end
  end

  task :seed_8a_users, [:csv_file_path] => [:environment, :log_to_stdout] do |t, args|
    csv_file = args[:csv_file_path]

    users_csv = CSV.read(csv_file)
    users_csv.shift # Remove Header Row

    Rails.logger.info "#{users_csv.count} records found in business.csv file to process."

    users_csv.each do |user|
      begin
        email = user[0].downcase
        bu = user[1]
        ds = user[2]
        role = user[3]
        business_unit = BusinessUnit.find_by_name bu
        duty_station = DutyStation.find_by_name ds
        u = User.find_by_email email

        if u.nil?
          Rails.logger.warn "No user found for email #{email}. Exiting can't process this record."
          Rails.logger.info "STATUS, NOT-CREATED"
          next
        end

        if u && u.roles.count == 0
          Rails.logger.info "Processing user with email - #{email}"
          u.duty_stations << duty_station
          u.roles_map = {"#{bu}".upcase => {"8a" => [role.downcase]}}
          u.save!
          u.office_locations.create!(business_unit_id: business_unit.id)

          # Setup Access Request
          req = SbaRoleAccessRequest.new
          req.roles_map = {"#{bu}".upcase => {"8a" => [role.downcase]}}
          req.user_id = u.id
          req.accepted_on = Time.now
          req.save!
          req.reload
          req.status = "accepted"
          req.duty_stations << duty_station
          req.save!
          Rails.logger.info "STATUS, CREATED"

        else
          Rails.logger.info "User already has roles - #{email}"
          Rails.logger.info "STATUS, EXISTS"
        end
      rescue Exception => e
        Rails.logger.info "Exception caught while processing record - #{email}. Message - #{e.message}"
        Rails.logger.info "STATUS, ERROR"
      end
    end

  end

  task :fix_duty_stations => [:environment, :log_to_stdout] do
    csv_file = 'lib/tasks/8a_users.csv'
    users_csv = CSV.read(csv_file)
    users_csv.shift # Remove Header Row

    Rails.logger.info "#{users_csv.count} records found in business.csv file to process."

    users_csv.each do |user|
      email = user[0]
      u = User.find_by_email email

      if u.nil?
        Rails.logger.warn "No user found for email #{email}. Exiting can't process this record."
        next
      end

      req = SbaRoleAccessRequest.find_by_user_id u.id

      if req.nil?
        Rails.logger.warn "No access request found for email #{email}. Exiting can't process this record."
        next
      end

      req.duty_stations = u.duty_stations
      req.save!

    end

  end

  desc "Assign BDMIS Migration applications to users specified in a csv file."
  task :assign_bdmis_archive_applications => [:environment, :log_to_stdout] do
    csv_file = 'lib/tasks/dc_bdmis_archive.csv'

    CSV.foreach(csv_file, :headers => true) do |row|
      email = row['email']
      duns = row['duns']
      begin
        org = Organization.find_by_duns_number duns
        u = User.find_by_email email

        if org.nil?
          Rails.logger.warn "No Org found for DUNS #{duns}. Exiting can't process this record."
          next
        end

        if u.nil?
          Rails.logger.warn "No user found for email #{email}. Exiting can't process this record."
          next
        end

        # hack to get the BDMIS Archive application
        app = org.sba_applications.where.not(bdmis_case_number: nil).first

        if u.nil?
          Rails.logger.warn "No BDMIS Arcive APP found for DUNS #{duns}. Exiting can't process this record."
          next
        end

        if app.reviews.count > 0
          Rails.logger.warn "Review already exits for #{duns}. Exiting can't process this record."
          next
        end

        if bdmis_archive_validate_permissions(u, app)
          app.start_review_process(u)

          # Setting the review in on completed state.
          review = app.current_review
          review.workflow_state = Review::EightA::SCREENING
          review.screening_due_date = nil
          review.determine_eligible = true
          review.save!

          ApplicationController.helpers.log_activity_application_state_change('screening', app.id, u.id)
          ApplicationController.helpers.log_activity_application_event('owner_changed', app.id, u.id, u.id)
        end
      rescue Exception => e
        Rails.logger.info "Exception caught while processing record - #{email}. Message - #{e.message}"
        Rails.logger.info "STATUS, ERROR"
      end
    end
  end

  def bdmis_archive_validate_permissions(user, app)
    # Maybe need to validate also some special conditions on applications
    if user.can?(:ensure_8a_role_district_office)
      return true
    else
      return false
    end
  end
end

def delete_interim_8a(duns)
  ActiveRecord::Base.transaction do
    begin
      if duns.present?
        org = Organization.find_by_duns_number(duns)
        # Get Interim Questionnaire
        q = Questionnaire.find_by_title("8(a) Interim Questionnaire")
        if org.present?
          cert = org.certificates.find_by_type("Certificate::EightA")
          if cert.present?
            apps = cert.sba_applications
            Rails.logger.info "Certificate for interim app found. Cert Id - #{cert.id}"
            Rails.logger.info "#{apps.count} Application versions found for the certificate. Proceeding to delete."
            apps.each do |app|
              # Validate if the app is a 8(a) interim one
              if app.questionnaire_id != q.id
                raise "Something wrong. Questionnaire on Application is not that of 8(a) Interim. Exiting"
              end
              Rails.logger.info "Deleting Application Id - #{app.id}"
              app.destroy!
            end
            # Delete certificate
            Rails.logger.info "Deleting Certificate Id - #{cert.id}"
            cert.destroy!
            Rails.logger.info "FYI: Successfully deleted 8(a) Interim app and certificate for DUNS: #{duns}"
          else
            Rails.logger.info "FYI: could not find an 8(a) Interim Certificate for DUNS : #{duns}. Proceeding to delete just draft application."
            remove_just_draft_8a_app(org, q)
          end
        else
          Rails.logger.info "FYI: could not find the org with duns: #{duns}"
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      Rails.logger.info e
    end
  end
end

def remove_just_draft_8a_app(org, q)
  app=org.sba_applications.find_by_questionnaire_id(q.id)
  Rails.logger.info "Processing app - #{app.id}"
  app.destroy!
end

## Try: $rake support:daily_application_report["/tmp/daily_application_report.txt"]
def daily_application_report(output_file = "/tmp/daily_application_report.txt")
  connection = ActiveRecord::Base.connection
  sql = <<-EOT.gsub(/^\s+\|/, '')
  | SELECT org.duns_number              AS duns_number,
  |        app.application_submitted_at AS application_submitted_at,
  |        r.workflow_state             AS review_status,
  |        r.screening_due_date         AS screening_due_date,
  |        mvw.legal_business_name      AS business_name,
  |        mvw.govt_bus_poc_email       AS business_email
  | FROM sbaone.sba_applications app
  | INNER JOIN sbaone.organizations org
  |       ON org.id=app.organization_id
  | INNER JOIN sbaone.reviews r
  |       ON r.sba_application_id=app.id
  | INNER JOIN reference.mvw_sam_organizations mvw
  |       ON mvw.duns = org.duns_number
  | WHERE app.type = 'SbaApplication::MasterApplication'
  |   AND app.deleted_at IS NULL
  |   AND app.workflow_state = 'submitted'
  |   AND app.id = r.sba_application_id
EOT

  result = connection.exec_query(sql)

  CSV.open("#{output_file}", "wb", force_quotes: true) do |csv|
    result.to_hash.each_with_index do |r, i|
      csv << r.keys if i == 0  ## print the header row
      csv << r.values
    end
  end
  ## Then: we allow email to be sent here
  email_addresses = if Rails.env.production? then
                      ["hilary.cronin@sba.gov","julin.justin@sba.gov"]
                    else
                      ["julin.justin@sba.gov"]
                    end
  DailyApplicationReportMailer.send_email(email_addresses, output_file).deliver
end
