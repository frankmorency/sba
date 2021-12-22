require 'sanitize'

class MessagesController < ApplicationDashboard::BaseController
  include MessagesHelper
  include DiscussionsHelper

end