class AddCheckConstraints < ActiveRecord::Migration
  def change
  end

  reversible do |dir|
    dir.up do
      # add a CHECK constraint
      execute <<-SQL
          ALTER TABLE sbaone.organizations
            ADD CONSTRAINT chk_tax_identifier_type
              CHECK (tax_identifier_type IN ('EIN', 'SSN'));
      SQL
    end
    dir.down do
      execute <<-SQL
          ALTER TABLE sbaone.organizations
            DROP CONSTRAINT tax_identifier_type
      SQL
    end
  end

end
