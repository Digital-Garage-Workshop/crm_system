class LlmFormatter::ConversationLlmFormatter < LlmFormatter::DefaultLlmFormatter
<<<<<<< HEAD
  def format
=======
  def format(config = {})
>>>>>>> upstream/develop
    sections = []
    sections << "Conversation ID: ##{@record.display_id}"
    sections << "Channel: #{@record.inbox.channel.name}"
    sections << 'Message History:'
    sections << if @record.messages.any?
<<<<<<< HEAD
                  build_messages
=======
                  build_messages(config)
>>>>>>> upstream/develop
                else
                  'No messages in this conversation'
                end

<<<<<<< HEAD
=======
    sections << "Contact Details: #{@record.contact.to_llm_text}" if config[:include_contact_details]

    attributes = build_attributes
    if attributes.present?
      sections << 'Conversation Attributes:'
      sections << attributes
    end

>>>>>>> upstream/develop
    sections.join("\n")
  end

  private

<<<<<<< HEAD
  def build_messages
    return "No messages in this conversation\n" if @record.messages.empty?

    message_text = ''
    @record.messages.chat.order(created_at: :asc).each do |message|
=======
  def build_messages(config = {})
    return "No messages in this conversation\n" if @record.messages.empty?

    messages = @record.messages.where.not(message_type: [:activity, :template])

    if config[:token_limit]
      build_limited_messages(messages, config)
    else
      build_all_messages(messages, config)
    end
  end

  def build_all_messages(messages, config)
    message_text = ''
    messages.order(created_at: :asc).each do |message|
      # Skip private messages unless explicitly included in config
      next if message.private? && !config[:include_private_messages]

>>>>>>> upstream/develop
      message_text << format_message(message)
    end
    message_text
  end

<<<<<<< HEAD
  def format_message(message)
    sender = message.message_type == 'incoming' ? 'User' : 'Support agent'
    "#{sender}: #{message.content}\n"
=======
  def build_limited_messages(messages, config)
    selected = []
    character_count = 0

    messages.reorder(created_at: :desc).each do |message|
      # Skip private messages unless explicitly included in config
      next if message.private? && !config[:include_private_messages]

      formatted = format_message(message)
      break if character_count + formatted.length > config[:token_limit]

      selected.prepend(formatted)
      character_count += formatted.length
    end

    selected.join
  end

  def format_message(message)
    sender = case message.sender_type
             when 'User'
               'Support Agent'
             when 'Contact'
               'User'
             else
               'Bot'
             end
    sender = "[Private Note] #{sender}" if message.private?
    "#{sender}: #{message.content_for_llm}\n"
  end

  def build_attributes
    attributes = @record.account.custom_attribute_definitions.with_attribute_model('conversation_attribute').map do |attribute|
      "#{attribute.attribute_display_name}: #{@record.custom_attributes[attribute.attribute_key]}"
    end
    attributes.join("\n")
>>>>>>> upstream/develop
  end
end
