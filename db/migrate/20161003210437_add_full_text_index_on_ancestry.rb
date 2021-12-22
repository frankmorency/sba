class AddFullTextIndexOnAncestry < ActiveRecord::Migration
  def change
    # Exclude Production because the index has been added manually
    if %w(dev development test qa demo_admin stage_admin).include? Rails.env
      # Postgres user running migration in Jenkins doesn't have sufficient privelges to install extension so commenting out
      # execute <<-SQL
      #   CREATE EXTENSION pg_trgm;
      #   CREATE INDEX index_sections_on_ancestry_full_text ON sbaone.sections USING gin (ancestry gin_trgm_ops);
      # SQL
    end
  end
end
