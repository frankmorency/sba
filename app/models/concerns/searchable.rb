module Searchable
  extend ActiveSupport::Concern

  included do
    mattr_accessor  :searchable_fields
  end

  module ClassMethods
    def searchable(fields)
      self.searchable_fields = fields
    end

    def sort_column(sort)
      searchable_fields[:fields].values.include?(sort) ? sort : searchable_fields[:fields][searchable_fields[:default]]
    end

    def searchable_field_columns
      searchable_fields[:fields].reject {|k, v| searchable_fields[:ignore].include?(k) }.values
    end

    def sort_direction(param = nil)
      param = param ? param : params[:direction]
      %w[asc desc].include?(param) ? param : "asc"
    end

    def sba_search(term, options = {})
      results = self

      unless term.blank?
        results = where(searchable_field_columns.map {|col| "#{col} LIKE ? "}.join(" OR "), *Array.new(searchable_field_columns.length, "%#{term}%"))
      end

      if options[:sort]
        results = results.order("#{sort_column(options[:sort][:column])} #{sort_direction(options[:sort][:direction])}")
      end

      results = results.paginate(page: options[:page] || 1, per_page: searchable_fields[:per_page] || 25)

      results
    end
  end
end