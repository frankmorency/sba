class MasterAppReturner
  include ActiveModel::Model

  attr_accessor :letter, :deliver_to, :subject, :message, :app
end