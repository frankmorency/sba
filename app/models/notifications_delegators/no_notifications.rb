require 'delegate'
# no notifications delegator
class NotificationsDelegators::NoNotifications < SimpleDelegator
  def to_partial_path
    'shared/notifications/no_notifications'
  end
end
