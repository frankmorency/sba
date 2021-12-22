require "sanitize"

module MessagesHelper
  include DiscussionsHelper
  include NotificationsHelper

  def self.sanitize_message(message_params)
    message_params["body"] = Sanitize.fragment(message_params["body"], MessagesHelper.sanitize_message_options)
    message_params
  end

  def self.sanitize_message_options
    # http://www.rubydoc.info/github/rgrove/sanitize/master#Custom_Configuration
    # This extends the Restricted config to only our list of tags
    Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
                           elements: %w[strong em u ul li ol p a],
                           attributes: { "a" => %w[href] },
                           protocols: { "a" => { "href" => %w[http https] } })
  end

  def index
    validate_scope
    response = CertifyMessages::Message.find(message_params)
    update_conversation_read_status response[:body]
    parse_response response
  end

  def new; end

  def create
    # Accomodating messaging-api / Certify gem. We must have message_params["body"] & message_params[:conversation_id] to work
    # Therefore I cannot just message_params.symbolize_keys!
    x = message_params
    x[:conversation_id] = message_params["conversation_id"]
    response = CertifyMessages::Message.create(MessagesHelper::sanitize_message(x))

    send_message_notification("8(a)", master_application_type(@sba_application), current_user.name, response[:body]["recipient_id"], @sba_application.id, User.find(response[:body]["recipient_id"]).email)
    redirect_to :back
  end

  def search; end

  def show; end

  private

  def validate_scope
    if current_user.is_vendor_or_contributor?
      my_params = { application_id: current_application.id, user_2: current_user.id }
      output = CertifyMessages::Conversation.find(my_params)[:body].select { |conversation| conversation["id"].to_i == message_params["conversation_id"].to_i }

      # if output.empty?
      #   return user_not_authorized
      # end
    end
  end

  # for each message in the conversation thread, check if it is was unread, mark it read
  def update_conversation_read_status(messages)
    return if messages.blank?
    messages_sort = messages.sort_by { |m| m["updated_at"] }.reverse

    messages_sort.each do |message|
      next if message["read"]
      next if message["sender_id"] == current_user.id

      if message["recipient_id"] == current_user.id
        CertifyMessages::Message.update(conversation_id: message["conversation_id"],
                                        id: message["id"],
                                        read: true)
      else
        message["read"] = true
      end

      if message["priority_read_receipt"]
        recipient = User.find(message["recipient_id"])
        sender = User.find(message["sender_id"])

        unless sender.is_vendor_or_contributor? # if we have an analyst as a sender then we need to send him the notification.
          conversation = CertifyMessages::Conversation.find(id: message["conversation_id"])
          CertifyNotifications::Notification.create("recipient_id" => message["sender_id"],
                                                    "application_id" => current_application.id,
                                                    "email" => sender.email,
                                                    "event_type" => "message",
                                                    "subtype" => "message_read",
                                                    "certify_link" => "/sba_applications/#{current_application.id}/conversations/#{message["conversation_id"]}/messages",
                                                    "priority" => true,
                                                    "options" => { recipient_name: "#{recipient.first_name} #{recipient.last_name}", conversation_subject: conversation[:body][0]["subject"] })
        end
      end
    end
    messages_sort
  end

  def parse_response(response)
    @body = {}
    @body[:messages] = response[:status] == 200 ? annotate_sender(response[:body]) : []
    @body[:conversation_id] = params[:conversation_id]
    @body[:conversation] = CertifyMessages::Conversation.find(id: @body[:conversation_id])[:body][0].symbolize_keys
  end

  def annotate_sender(messages)
    uniq_ids = messages.uniq { |m| m[:sender_id] }
    messages.each do |message|
      message["sender"] = if message["sender_id"] == uniq_ids[0]["sender_id"]
          true
        else
          false
        end
    end
    messages
  end

  def message_params
    params.permit(:id, :conversation_id, :sender_id, :recipient_id, :body, :read, :sent, :priority_read_receipt).to_h
  end
end
