require 'will_paginate/collection'

# notifications controller
class NotificationsController < ApplicationController
  def index
    if Feature.active?(:notifications)
      fetch_notification_list
    else
      head :ok # :service_unavailable ?
    end
  end

  def check_notifications
    if Feature.active?(:notifications)
      fetch_notification_list
      render partial: "shared/notifications/notifications_drawer"
    else
      head :ok # :service_unavailable ?
    end
  end

  def check_for_new
    if Feature.active?(:notifications)
      safe_params = params.permit('most_recent_notification')
      if current_user.blank?
        response = { message: 'user not logged in' }
        render json: response, status: :forbidden
      else
        notifications = fetch_notification_list
        response = parse_new_notification_response safe_params, notifications
        render json: response, status: :ok
      end
    else
      head :service_unavailable
    end
  rescue
    render json: { message: 'rescue NotificationsController#check_for_new' }, status: :internal_server_error
  end

  def update_status
    if Feature.active?(:notifications)
      CertifyNotifications::Notification.update(update_safe_params)
    end

    render nothing: true, status: :ok
  end

  private

  def parse_new_notification_response(safe_params, notifications)
    if notifications.blank? || safe_params['most_recent_notification'].blank?
      { message: 'no notifications', new_notifications: false, most_recent_notification: nil }
    elsif notifications.first['id'].to_s == safe_params['most_recent_notification']
      { message: 'no new notifications', new_notifications: false, most_recent_notification: notifications.first['id'] }
    else
      { message: 'new notifications found', new_notifications: true, most_recent_notification: notifications.first['id'] }
    end
  end

  def fetch_notification_list
    return nil if current_user.blank?
    notification_list = CertifyNotifications::Notification.find(recipient_id: current_user.id, page: params[:page], per_page: params[:per_page])[:body]
    handle_notifications(notification_list)
  end

  def handle_notifications(notification_list)
    notifications = notification_list["items"]
    current_page = notification_list["current_page"]
    per_page = notification_list["per_page"]
    total_entries = notification_list["total_entries"]    
    @notifications = notifications.blank? ? no_notifications(notifications) : notifications_list(notifications, current_page, per_page, total_entries)
  end

  def notifications_list(notifications, current_page, per_page, total_entries)
    notification_list = NotificationsDelegators::NotificationsList.new(assign_read_unread_class(notifications))
    # Using will_paginate with an API and Gem requires the pagination to be created manually
    notification_list = WillPaginate::Collection.create(current_page, per_page, total_entries) do |pager|
      pager.replace notification_list
    end
  end

  def no_notifications(empty_notifications)
    NotificationsDelegators::NoNotifications.new(empty_notifications)
  end

  def assign_read_unread_class(notifications)
    notifications.map do |notification|
      notification['read'] ? NotificationsDelegators::ReadNotification.new(notification) : NotificationsDelegators::UnreadNotification.new(notification)
    end
  end

  def update_safe_params
    params.permit(:id, :read)
  end
end
