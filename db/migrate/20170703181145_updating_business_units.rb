class UpdatingBusinessUnits < ActiveRecord::Migration
  def change

    bu_list = %w(CODS DISTRICT_OFFICE AREA_OFFICE HQ_LEGAL OIG HQ_PROGRAM HQ_AA HQ_CE WOSB MPP HUBZONE)

    i = 0
    BusinessUnit.all.each do |bu|
      bu.name = bu_list[i]
      bu.save!
      i = i + 1
    end

    # Deleting the biz units.
    BusinessUnit.where(name: nil).destroy_all
  end
end
