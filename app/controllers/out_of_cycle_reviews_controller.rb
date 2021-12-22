class OutOfCycleReviewsController < ApplicationController
  before_action :set_organization, only: [:new, :create]

  def new
  end

  def create
  end

  protected

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end