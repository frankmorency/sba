# Notes:
# I am using HelpPage.last in case we want to have multiple help pages later we can had the code to find those pages.
#
class HelpPagesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_filter :set_paper_trail_whodunnit
  before_action :set_page, only: [:index, :edit, :update]
  # before_action :determine_public_or_private
  before_action :set_public_flag

  def index
  end

  def edit
  end

  def update
    if @page.update_attributes(help_page_params)
      redirect_to action: :index
    else
      redirect_to action: :edit
    end
  end

  private

  def set_page
    @page = HelpPage.last
  end

  def help_page_params
    params.require(:help_page).permit(:title, :left_panel, :right_panel)
  end

  def require_help_pages_support
    user_not_authorized unless current_user.can? :mange_help_pages
  end

  def determine_public_or_private
    if user_signed_in?
      set_private_flag
    else
      set_public_flag
    end
  end
end
