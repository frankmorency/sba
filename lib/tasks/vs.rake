namespace :vs do
  desc "Activate voluntarily suspended certs"
  task activate: :environment do
    VoluntarySuspension.extended.find_each do |vs|
      if vs.certificate.expiry_date.to_date == Date.today
        vs.certificate.update_attribute(:workflow_state, "active")
      end
    end
  end
end
