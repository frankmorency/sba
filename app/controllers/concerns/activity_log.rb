module ActivityLog
  extend ActiveSupport::Concern

  private

  def set_activities
    # If the activity log service is down, Certify will log these errors and allow the original transaction to be successful
    begin
      @activities = fetch_activity_list(CertifyActivityLog::Activity.where(application_id: @sba_application.id, page: params[:page], per_page: params[:per_page])[:body])
    rescue => e
      Rails.logger.error "Activity log service is down: #{e.message}"
      @activities = []
    end
  end

  def fetch_activity_list(activity_list)
    @activities = activity_list["items"]
    # support for pagination
    current_page = activity_list["current_page"]
    per_page = activity_list["per_page"]
    total_entries = activity_list["total_entries"]
    #create variable for external access
    @activity_list = @activities
    
    # Using kaminari with an API and Gem requires the pagination to be created manually
    @activity_list = Kaminari.paginate_array(@activity_list, total_count: total_entries).page(current_page).per(per_page) do |pager|
      pager.replace @activity_list
    end

    update_pagination_window_size(current_page, @activity_list.total_pages)

    @activity_list
  end

  def update_pagination_window_size(current_page, total_pages)
    @window_size = 2
    @window_size = 5 if [1, total_pages].include?(current_page)
    @window_size = 4 if [2, total_pages - 1].include?(current_page)
    @window_size = 3 if [3, total_pages - 2].include?(current_page)
  end
end