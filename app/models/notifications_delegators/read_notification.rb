require 'delegate'
# read notifications delegator for notificationss
class  NotificationsDelegators::ReadNotification < SimpleDelegator
  def to_partial_path
    'shared/notifications/read_notification'
  end
end
