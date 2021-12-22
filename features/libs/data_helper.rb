module DataHelper
  # Read basics on YAML - http://www.seleniumframework.com/test-data/test-data-with-yaml/
  def data_yml_hash
    @data_yml = YAML.load_file "#{data_default_directory}/#{yml_file}"
  end

  def data_yml
    @data_yml = YAML.load(File.read "#{data_default_directory}/#{yml_file}")
  end

  def comp_data_yml
    @data_yml = YAML.load(File.read "#{data_default_directory}/#{comp_file}")
  end

  # Read basics on excel parsing - http://www.seleniumframework.com/test-data/test-data-with-excel/
  def data_excel_hash (data_sheet)
    workbook = RubyXL::Parser.parse data_default_directory+'/'+excel_file
    sheet = workbook[data_sheet]
    header_row = sheet.sheet_data[0]
    @data_excel = sheet.get_table(header_row)
  end

  # Json parsing reference - http://www.seleniumframework.com/test-data/test-data-with-json/
  def data_json_hash
    @data_json = JSON.parse data_default_directory+'/'+json_file
  end

  def set_data_directory(dir)
    @data_directory = dir
  end

  private

  def excel_file
    ENV['DATA_EXCEL_FILE']?ENV['DATA_EXCEL_FILE'] : 'default.xlsx'
  end

  def json_file
    ENV['DATA_JSON_FILE']?ENV['DATA_JSON_FILE'] : 'default.json'
  end

  def xml_file
    ENV['DATA_XML_FILE']?ENV['DATA_XML_FILE'] : 'default.xml'
  end

  def data_pdf(_file)
    @data_file = File.absolute_path("#{data_default_directory}/#{_file}")
  end

  def data_docx(_file)
    @data_file = File.absolute_path("#{data_default_directory}/#{_file}")
  end

  def data_default_directory
    @data_directory ||= 'features/libs/config/data'
  end

  def in_array?(array, matching_string)
    matching_string = [matching_string] unless matching_string.is_a?(Array)
    matching_string == array & matching_string
  end

  class << self
    attr_accessor :data_yml,
                  :comp_data_yml,
                  :data_excel,
                  :data_json,
                  :data_xml,
                  :data_directory,
                  :data_yml,
                  :data_yml_hash,
                  :data_pdf,
                  :data_docx,
                  :in_array
  end
end
