class AddDocumentColumnToVoluntarySuspensionsTable < ActiveRecord::Migration
  def up
    add_attachment :voluntary_suspensions, :document
  end

  def down
    remove_attachment :voluntary_suspensions, :document
  end
end
