module Admin
  class DataDictionaryController < BaseController
    def index
      tables = DatabaseInspector.tables
      @tables_columns = DatabaseInspector.table_columns_hash(tables)
      @tables_columns_array = []
      @tables_columns.each do |table, cols|
        single_table = {}
        single_table[table] = cols
        @tables_columns_array << single_table
      end
    end

    def csv_download
      respond_to do |format|
        format.csv {send_data DatabaseInspector.create_csv(params[:table]), filename: "data_dictionary_export_#{params[:table]}.csv"}
      end
    end

    def csv_download_all
      respond_to do |format|
        format.csv {send_data DatabaseInspector.create_csv(DatabaseInspector.tables), filename: "data_dictionary_export.csv"}
      end
    end
  end
end