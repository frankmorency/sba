class FinancialSummary
  class Base
    attr_accessor :contributor, :answers, :total

    FORMATS = %w(none currency).map(&:to_sym)

    def initialize(contributor, app)
      @contributor = contributor
      @app = app
    end

    def present?
      false
    end

    def to_table
      return <<-EOF
        <table>
          <thead>
            <tr>#{headings}</tr>
          </thead>
          <tbody>
            #{rows}
            #{total_row}
          </tbody>
        </table>
      EOF
      .html_safe
    end

    def headings
      heading_labels.map {|heading| "<th>#{heading}</th>" }.join("\n")
    end

    def rows
      output = ''
      answers.each do |data|
        output << row(data)
      end
      output
    end

    def row(data)
      output = '<tr>'
      field_labels.each do |field|
        if formatting[field] == :currency && ! data[field].blank?
          output << "<td>#{sanitize(helper.number_to_currency(data[field]))}</td>"
        else
          output << "<td>#{sanitize(data[field])}</td>"
        end
      end
      output << '</tr>'
      output
    end

    def total_row
      ''
    end

    protected

    def sanitize(data)
      return '' unless data
      ActiveRecord::Base.connection.quote(data)[1...-1]
    end

    def helper
      @helper ||= Class.new do
        include ActionView::Helpers::NumberHelper
      end.new
    end
  end
end