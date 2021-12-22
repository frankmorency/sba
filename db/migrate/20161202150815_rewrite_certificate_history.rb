class RewriteCertificateHistory < ActiveRecord::Migration
  def change
    
    Certificate.order(created_at: :desc).group_by(&:organization).each do |org, certificates|
      puts "Rewriting certificates for #{org.name}"

      certificates.group_by(&:certificate_type).each do |type, certs|
        certificate = certs.shift

        puts "Initial #{type.name} Cert: #{certificate.workflow_state} #{certificate.id} (#{certificate.workflow_changes.pluck(:workflow_state)})"

        # go through each certificate and
        certs.each do |cert|
          # 1. reassign it's application to the initial certificate
          SbaApplication.where(certificate_id: cert).each do |app|
            app.update_attribute(:certificate_id, certificate.id)
          end

          puts "#{type.name}: #{cert.workflow_state} #{cert.id} (#{cert.workflow_changes.pluck(:workflow_state)})"

          # 2. update the certificates workflow history to include that certificate's state
          certificate.workflow_changes.create!(workflow_state: cert.workflow_state, user_id: nil, created_at: cert.created_at, updated_at: cert.updated_at)

          # 3. delete that certificate
          cert.delete
        end

        # find any rogue apps without certificates
        rogue_app = org.sba_applications.order(created_at: :asc).where(certificate_id: nil, certificate_type_id: type.id).first

        if rogue_app
          puts "updating app #{rogue_app.id} (#{rogue_app.workflow_state}) to cert #{certificate.id}"
          rogue_app.update_attribute(:certificate_id, certificate.id)
        end
      end
    end
  end
end
