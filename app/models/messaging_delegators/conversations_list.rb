require 'delegate'
# unread message delegator for messages
class MessagingDelegators::ConversationsList < SimpleDelegator
  # use all methods from object
  def to_partial_path
    'shared/conversations/conversations_list'
  end
end
