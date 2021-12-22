class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_organization
  before_action :ensure_organization_user
end