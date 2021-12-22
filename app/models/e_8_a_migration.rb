# This class follows the pattern in app/models/bdmis_migration.rb
# We keep a record in a table for every row imported, with the error message if any.
class E8aMigration < ActiveRecord::Base
  def self.log_success!(attributes, unique_number)
    create! ({unique_number: unique_number, fields: attributes})
  end

  def self.log_failure!(attributes, unique_number, errors)
    create! ({unique_number: unique_number, fields: attributes, error_messages: errors})
  end
end