class ReplyMailbox < ApplicationMailbox
<<<<<<< HEAD
  attr_accessor :conversation_uuid, :processed_mail

  # Last part is the regex for the UUID
  # Eg: email should be something like : reply+6bdc3f4d-0bec-4515-a284-5d916fdde489@domain.com
  EMAIL_PART_PATTERN = /^reply\+([0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12})$/i

  before_processing :conversation_uuid_from_to_address,
                    :find_relative_conversation

  def process
    return if @conversation.blank?

    decorate_mail
    create_message
    add_attachments_to_message
=======
  attr_accessor :conversation, :processed_mail

  before_processing :find_conversation

  def process
    # Return early if no conversation was found (e.g., notification emails, suspended accounts)
    return unless @conversation

    # Wrap everything in a transaction to ensure atomicity
    # This prevents orphan conversations if message/attachment creation fails
    # and ensures idempotency on job retry (conversation won't be duplicated)
    ActiveRecord::Base.transaction do
      persist_conversation_if_needed
      decorate_mail
      create_message
      add_attachments_to_message
    end
>>>>>>> upstream/develop
  end

  private

<<<<<<< HEAD
  def find_relative_conversation
    if @conversation_uuid
      find_conversation_with_uuid
    elsif mail.in_reply_to.present?
      find_conversation_with_in_reply_to
    end
  end

  def conversation_uuid_from_to_address
    @mail = MailPresenter.new(mail)

    return if @mail.mail_receiver.blank?

    @mail.mail_receiver.each do |email|
      username = email.split('@')[0]
      match_result = username.match(ApplicationMailbox::REPLY_EMAIL_UUID_PATTERN)
      if match_result
        @conversation_uuid = match_result.captures
        break
      end
    end
    @conversation_uuid
  end

  # find conversation uuid from below pattern
  # reply+<conversation-uuid>@<mailer-domain.com>
  def find_conversation_with_uuid
    @conversation = Conversation.find_by(uuid: conversation_uuid)
    validate_resource @conversation
  end

  def find_conversation_by_uuid(match_result)
    @conversation_uuid = match_result.captures[0]

    find_conversation_with_uuid
  end

  def find_conversation_by_message_id(in_reply_to)
    @message = Message.find_by(source_id: in_reply_to)
    @conversation = @message.conversation if @message.present?
    @conversation_uuid = @conversation.uuid if @conversation.present?
  end

  # find conversation uuid from below pattern
  # <conversation/#{@conversation.uuid}/messages/#{@messages&.last&.id}@#{@account.inbound_email_domain}>
  def find_conversation_with_in_reply_to
    match_result = nil
    in_reply_to_addresses = mail.in_reply_to
    in_reply_to_addresses = [in_reply_to_addresses] if in_reply_to_addresses.is_a?(String)
    in_reply_to_addresses.each do |in_reply_to|
      match_result = in_reply_to.match(::ApplicationMailbox::CONVERSATION_MESSAGE_ID_PATTERN)
      break if match_result
    end
    find_by_in_reply_to_addresses(match_result, in_reply_to_addresses)
  end

  def find_by_in_reply_to_addresses(match_result, in_reply_to_addresses)
    find_conversation_by_uuid(match_result) if match_result
    find_conversation_by_message_id(in_reply_to_addresses) if @conversation.blank?
  end

  def validate_resource(resource)
    Rails.logger.error "[App::Mailboxes::ReplyMailbox] Email conversation with uuid: #{conversation_uuid} not found" if resource.nil?

    resource
=======
  def find_conversation
    @conversation = Mailbox::ConversationFinder.new(mail).find
    # Log when email is rejected
    Rails.logger.info "Email #{mail.message_id} rejected - no conversation found" unless @conversation
  end

  def persist_conversation_if_needed
    # Save the conversation if it's a new record (from NewConversationStrategy)
    # We persist here instead of in the strategy to maintain transaction integrity
    return unless @conversation.new_record?

    @conversation.save!
    Rails.logger.info "Created new conversation #{@conversation.id} for email #{mail.message_id}"
>>>>>>> upstream/develop
  end

  def decorate_mail
    @processed_mail = MailPresenter.new(mail, @conversation.account)
  end
end
