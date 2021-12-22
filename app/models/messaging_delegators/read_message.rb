require 'delegate'
# read message delegator for messages
class MessagingDelegators::ReadMessage < SimpleDelegator
  def to_partial_path
    'shared/conversations/read_message'
  end
end
