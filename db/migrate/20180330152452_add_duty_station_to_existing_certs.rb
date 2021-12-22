class AddDutyStationToExistingCerts < ActiveRecord::Migration
  def change
    Certificate.where(type: 'Certificate::EightA').each do |certificate|
      if certificate.duty_station_id.nil?
        # find associated master application
        eight_a_initial = certificate.sba_applications.where(type: 'SbaApplication::MasterApplication').where(kind: 'initial').first

        if eight_a_initial
          # pick first duty station - SHOULD ONLY BE ONE BUT ASSOCIATION WAS INCORRECTLY SET
          duty_station = eight_a_initial.duty_stations.first

          # assign duty station to certificate
          certificate.duty_station = duty_station if duty_station
          certificate.save!
        end
      end
    end

  end
end
