class ConversationsController < ApplicationDashboard::BaseController
  include ConversationsHelper
  include DiscussionsHelper

  helper_method :current_application
  helper_method :current_recipient

  before_action :get_application_to_message
  before_action :get_vendors_and_contributors, only: [:new, :create]
  before_action :validate_conversation_user, only: [:create]

end