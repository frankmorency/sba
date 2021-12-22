class CreateAgencyRequirementOrganizations < ActiveRecord::Migration
  def change
    create_table :agency_requirement_organizations do |t|
      t.references :agency_requirement, index: true, foreign_key: true
      t.references :organization, index: true, foreign_key: true
      t.datetime "deleted_at"
      t.timestamps
    end
    # remove organization_id from agency_requirements
    remove_column :agency_requirements, :organization_id
    # constraints allow duplicate null values in deleted_at, use two partial unique indexes instead 
    execute <<-SQL
      CREATE UNIQUE INDEX aro_3col_uni_idx ON "sbaone"."agency_requirement_organizations" (agency_requirement_id, organization_id, deleted_at)
      WHERE deleted_at IS NOT NULL;
      CREATE UNIQUE INDEX aro_2col_uni_idx ON "sbaone"."agency_requirement_organizations" (agency_requirement_id, organization_id)
      WHERE deleted_at IS NULL;
    SQL
  end
end
