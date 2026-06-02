class MessageTemplates::Template::CsatSurvey
  pattr_initialize [:conversation!]

  def perform
    ActiveRecord::Base.transaction do
      conversation.messages.create!(csat_survey_message_params)
    end
  end

  private

<<<<<<< HEAD
  delegate :contact, :account, to: :conversation
  delegate :inbox, to: :message
=======
  delegate :contact, :account, :inbox, to: :conversation

  def message_content
    return I18n.t('conversations.templates.csat_input_message_body') if csat_config.blank? || csat_config['message'].blank?

    csat_config['message']
  end
>>>>>>> upstream/develop

  def csat_survey_message_params
    {
      account_id: @conversation.account_id,
      inbox_id: @conversation.inbox_id,
      message_type: :template,
      content_type: :input_csat,
<<<<<<< HEAD
      content: I18n.t('conversations.templates.csat_input_message_body')
=======
      content: message_content,
      content_attributes: content_attributes
    }
  end

  def csat_config
    inbox.csat_config || {}
  end

  def content_attributes
    {
      display_type: csat_config['display_type'] || 'emoji'
>>>>>>> upstream/develop
    }
  end
end
