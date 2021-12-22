require 'delegate'
# notifications list delegator
class  NotificationsDelegators::NotificationsList < SimpleDelegator
  # use all methods from object
  def to_partial_path
    'shared/notifications/notifications_list'
  end
end
