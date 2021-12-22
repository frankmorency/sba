require 'delegate'
# unread message delegator for messages
class MessagingDelegators::UnreadMessage < SimpleDelegator
  # use all methods from object
  def to_partial_path
    'shared/conversations/unread_message'
  end
end
