class AddRefToVoluntarySuspension < ActiveRecord::Migration
  def change
    add_reference :voluntary_suspensions, :organization, foreign_key: true
    add_reference :voluntary_suspensions, :certificate, foreign_key: true
  end

  # def change
  #   add_reference :voluntary_suspensions, :organization, index: true
  #   add_foreign_key :voluntary_suspensions, :organizations
  #   add_reference :voluntary_suspensions, :certificate, index: true
  #   add_foreign_key :voluntary_suspensions, :certificates
  # end
end
