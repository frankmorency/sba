class DatabaseInspector < ActiveRecord::Base
  PROBLEM_TABLES = ["ar_internal_metadata", "application_status_histories", "schema_migrations", "duty_stations_sba_applications", "certificate_status_histories", "eligibility_results", "users_roles", "sam_organizations", "versions", "sessions", "ckeditor_assets", "e8a_migrations"]

  def self.column_comment table_name, column_name
    table_catalog = %w(development).include?(Rails.env) ? "'sbaone_dev'":"'sbaone'"
    table_name_sanitized = ActiveRecord::Base.connection.quote(table_name) #sanitize input
    column_name_sanitized = ActiveRecord::Base.connection.quote(column_name) #sanitize input
    oid = ActiveRecord::Base.connection.quote(get_oid table_name)
    query = <<~SQL
      SELECT col_description(#{oid},
        (SELECT ordinal_position
         FROM   information_schema.columns
         WHERE  table_catalog = #{table_catalog}
           AND column_name = #{column_name_sanitized}
           AND table_name = #{table_name_sanitized})
      )
    SQL
    ActiveRecord::Base.connection.execute(query).to_a.dig(0, 'col_description')
  end

  def self.table_comment table_name
    oid = get_oid table_name
    oid_sanitized = ActiveRecord::Base.connection.quote(oid)
    query = "SELECT obj_description((#{oid_sanitized}), ('pg_class'))"
    ActiveRecord::Base.connection.execute(query).to_a.dig(0, 'obj_description')
  end

  def self.get_oid table_name
    table_name_sanitized = ActiveRecord::Base.connection.quote(table_name) #sanitize input
    ActiveRecord::Base.connection.execute("select oid from pg_class where relname=#{table_name_sanitized}").to_a.dig(0, 'oid')
  end

  def self.tables
    ActiveRecord::Base.connection.tables.sort.delete_if {|table| PROBLEM_TABLES.include?(table)}
  end

  def self.table_columns_hash tables
    # create hash with key = table_name and value = array of table_columns
    tables_columns = {}
    tables.each do |table|
      tables_columns[table] = table.classify.constantize.column_names
    end
    tables_columns
  end

  def self.create_csv tables
    tables = Array(tables) if tables.is_a?(String)
    tables_columns = self.table_columns_hash(tables)
    header = ["Column", "Comment"]

    CSV.generate(headers: true) do |csv|
      tables_columns.each do |table, columns|
        csv << Array("Table: "+table)
        csv << header
        columns.each do |column|
          csv << [column, DatabaseInspector.column_comment(table, column)]
        end
      end
    end
  end

end