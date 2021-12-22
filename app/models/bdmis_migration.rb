class BdmisMigration < ActiveRecord::Base
  belongs_to :sba_application

  def self.log_success!(attributes, app_id)
    create! hashed_attributes(attributes).merge(sba_application_id: app_id)
  end

  def self.log_failure!(attributes, errors)
    create! hashed_attributes(attributes).merge(error_messages: errors)
  end

  def self.hashed_attributes(attributes)
    attributes.respond_to?(:to_hash) ? attributes.to_hash : attributes
  end

  %w(approval_date decline_date next_review exit_date submitted_on_date approved_date).each do |meth|
    define_method(:"#{meth}=") do |value|
      write_attribute meth.to_sym, Chronic.parse(value)
    end
  end
end
