require 'delegate'
# unread notifications delegator for notificationss
class NotificationsDelegators::UnreadNotification < SimpleDelegator
  def to_partial_path
    'shared/notifications/unread_notification'
  end
end
