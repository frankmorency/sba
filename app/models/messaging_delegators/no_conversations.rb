require 'delegate'
# read message delegator for messages
class MessagingDelegators::NoConversations < SimpleDelegator
  def to_partial_path
    'shared/conversations/no_conversations'
  end
end
