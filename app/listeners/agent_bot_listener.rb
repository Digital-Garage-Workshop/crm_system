class AgentBotListener < BaseListener
  def conversation_resolved(event)
    conversation = extract_conversation_and_account(event)[0]
    inbox = conversation.inbox
<<<<<<< HEAD
    return unless connected_agent_bot_exist?(inbox)

    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name)
    process_webhook_bot_event(inbox.agent_bot, payload)
=======
    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name)
    agent_bots_for(inbox, conversation).each { |agent_bot| process_webhook_bot_event(agent_bot, payload) }
>>>>>>> upstream/develop
  end

  def conversation_opened(event)
    conversation = extract_conversation_and_account(event)[0]
    inbox = conversation.inbox
<<<<<<< HEAD
    return unless connected_agent_bot_exist?(inbox)

    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name)
    process_webhook_bot_event(inbox.agent_bot, payload)
=======
    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name)
    agent_bots_for(inbox, conversation).each { |agent_bot| process_webhook_bot_event(agent_bot, payload) }
  end

  def conversation_status_changed(event)
    conversation = extract_conversation_and_account(event)[0]
    changed_attributes = extract_changed_attributes(event)
    inbox = conversation.inbox
    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name, changed_attributes: changed_attributes)
    agent_bots_for(inbox, conversation).each { |agent_bot| process_webhook_bot_event(agent_bot, payload) }
  end

  def conversation_updated(event)
    conversation = extract_conversation_and_account(event)[0]
    changed_attributes = extract_changed_attributes(event)
    inbox = conversation.inbox
    event_name = __method__.to_s
    payload = conversation.webhook_data.merge(event: event_name, changed_attributes: changed_attributes)
    agent_bots_for(inbox, conversation).each { |agent_bot| process_webhook_bot_event(agent_bot, payload) }
>>>>>>> upstream/develop
  end

  def message_created(event)
    message = extract_message_and_account(event)[0]
    inbox = message.inbox
<<<<<<< HEAD
    return unless connected_agent_bot_exist?(inbox)
    return unless message.webhook_sendable?

    method_name = __method__.to_s
    process_message_event(method_name, inbox.agent_bot, message, event)
=======
    return unless message.webhook_sendable?

    method_name = __method__.to_s
    agent_bots_for(inbox, message.conversation).each { |agent_bot| process_message_event(method_name, agent_bot, message, event) }
>>>>>>> upstream/develop
  end

  def message_updated(event)
    message = extract_message_and_account(event)[0]
    inbox = message.inbox
<<<<<<< HEAD
    return unless connected_agent_bot_exist?(inbox)
    return unless message.webhook_sendable?

    method_name = __method__.to_s
    process_message_event(method_name, inbox.agent_bot, message, event)
=======
    return unless message.webhook_sendable?

    method_name = __method__.to_s
    agent_bots_for(inbox, message.conversation).each { |agent_bot| process_message_event(method_name, agent_bot, message, event) }
>>>>>>> upstream/develop
  end

  def webwidget_triggered(event)
    contact_inbox = event.data[:contact_inbox]
    inbox = contact_inbox.inbox
<<<<<<< HEAD
    return unless connected_agent_bot_exist?(inbox)

    event_name = __method__.to_s
    payload = contact_inbox.webhook_data.merge(event: event_name)
    payload[:event_info] = event.data[:event_info]
    process_webhook_bot_event(inbox.agent_bot, payload)
=======
    event_name = __method__.to_s
    payload = contact_inbox.webhook_data.merge(event: event_name)
    payload[:event_info] = event.data[:event_info]
    agent_bots_for(inbox).each { |agent_bot| process_webhook_bot_event(agent_bot, payload) }
>>>>>>> upstream/develop
  end

  private

<<<<<<< HEAD
  def connected_agent_bot_exist?(inbox)
    return if inbox.agent_bot_inbox.blank?
    return unless inbox.agent_bot_inbox.active?

    true
=======
  def agent_bots_for(inbox, conversation = nil)
    bots = []
    bots << conversation.assignee_agent_bot if conversation&.assignee_agent_bot.present?
    inbox_bot = active_inbox_agent_bot(inbox)
    bots << inbox_bot if inbox_bot.present?
    bots.compact.uniq
  end

  def active_inbox_agent_bot(inbox)
    return unless inbox.agent_bot_inbox&.active?

    inbox.agent_bot
>>>>>>> upstream/develop
  end

  def process_message_event(method_name, agent_bot, message, _event)
    # Only webhook bots are supported
    payload = message.webhook_data.merge(event: method_name)
    process_webhook_bot_event(agent_bot, payload)
  end

  def process_webhook_bot_event(agent_bot, payload)
    return if agent_bot.outgoing_url.blank?

<<<<<<< HEAD
    AgentBots::WebhookJob.perform_later(agent_bot.outgoing_url, payload)
=======
    AgentBots::WebhookJob.perform_later(agent_bot.outgoing_url, payload, :agent_bot_webhook,
                                        secret: agent_bot.secret, delivery_id: SecureRandom.uuid)
>>>>>>> upstream/develop
  end
end
