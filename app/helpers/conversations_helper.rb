module ConversationsHelper
  include DiscussionsHelper
  include NotificationsHelper

  # simple helper with Nokogiri to get only the text bits of an html blob, separated by a space
  def self.safe_html(html_string)
    Nokogiri::HTML(html_string).xpath("//text()").map(&:text).join(" ")
  end

  def index
    # I cannot scope to organization for sba_users
    my_params = {application_id: @sba_application.id}
    if current_user.is_vendor_or_contributor?
      # Scoping to organizaton for vendors.
      my_params = {application_id: current_application.id, user_2: current_user.id}
    end

    output = CertifyMessages::Conversation.find(my_params)[:body]
    @output_conversations = output.blank? ? no_conversations(output) : conversations_list(output)
  end

  def create
    my_params = message_params
    my_params[:application_id] = message_params["sba_application_id"]
    if current_user.is_sba?
      # this is to set the user selected from the drop down
      my_params["recipient_id"] = message_params["user_2"]
    end
    response = CertifyMessages::Conversation.create_with_message(MessagesHelper::sanitize_message(my_params))
    conversation_id = nil
    begin
      conversation_id = response[:conversation][:body]['id']
      raise "We don't have a Conversation ID please check what's up with Messaging-API" if conversation_id.nil?
    end

    send_message_notification("8(a)", master_application_type(current_application), current_user.name, my_params["recipient_id"], current_application.id, User.find(my_params["recipient_id"]).email)
    redirect_to sba_application_conversation_messages_path(sba_application_id: message_params["sba_application_id"], conversation_id: conversation_id)
  end

  def show; end

  def update; end

  def destroy; end

  def new; end

  protected

  # This validates that there is no possible conversation between 2 sba users or 2 vendors.
  def validate_conversation_user
    user_one = User.find message_params["user_1"]
    user_two = User.find message_params["user_2"]

    if user_one.is_sba? && user_two.is_sba?
      flash[:error] = "You cannot sent a message to another SBA user."
      redirect_to new_conversation_path(sba_application_id: message_params["application_id"])
    elsif user_one.is_vendor_or_contributor? && user_two.is_vendor_or_contributor?
      flash[:error] = "You cannot sent a message to someone other that SBA users working on your case."
      redirect_to new_conversation_path(sba_application_id: message_params["application_id"])
    end
  end

  def get_vendors_and_contributors
    # if we have an analyst that wants to respond to an
    if current_user.is_sba?
      @dropdown = []
      current_application.current_users.each do |u|
        @dropdown <<  [u.name, u.id] if u.deleted_at.nil?
      end
      return @dropdown
    end
  end

  private

  def conversations_list(conversations)
    MessagingDelegators::ConversationsList.new(assign_read_unread_class(conversations))
  end

  def no_conversations(empty_conversations)
    MessagingDelegators::NoConversations.new(empty_conversations)
  end

  def assign_read_unread_class(conversations)
    begin
      conversations.map do |conversation|
        # if I am the recipient show the unread marker. otherwise mark the message as read for everyone else.
        if conversation['most_recent_message'] && conversation['most_recent_message']['recipient_id'] == current_user.id
          read_messsage(conversation) ? MessagingDelegators::ReadMessage.new(conversation) : MessagingDelegators::UnreadMessage.new(conversation)
        else
          MessagingDelegators::ReadMessage.new(conversation)
        end
      end
    rescue Exception => e
      raise "Somthing is wrong with the API "
    end
  end

  def read_messsage(conversation)
    conversation['most_recent_message'].blank? || conversation['most_recent_message']['read'] || own_message(conversation)
  end

  def own_message(conversation)
    !conversation['most_recent_message']['read'] && conversation['most_recent_message']['sender_id'] == current_user.id
  end

  def message_params
    params.permit(:subject, :user_1, :user_2, :sba_application_id, :body, :sender_id, :recipient_id, :current_recipient,  :conversation_id, :read, :sent, :priority_read_receipt, :conversation_type).to_h
  end

  def get_application_to_message
    current_application
  end
end
