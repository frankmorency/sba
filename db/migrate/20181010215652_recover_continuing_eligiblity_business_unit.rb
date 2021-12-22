class RecoverContinuingEligiblityBusinessUnit < ActiveRecord::Migration
  def change
    bu_ce = BusinessUnit.unscoped.where("name = ?", "HQ_CE").first
    eight_a = Program.find_by(name: 'eight_a')
    if bu_ce.present?
      bu_ce.update_attributes(deleted_at: nil)
      bu_ce.update_attributes(title: 'Continuing Eligibility', program_id: eight_a.id)
    end
  end
end
