#######################################
# To create a whatsapp provider
# - Inherit this as the base class.
# - Implement `send_message` method in your child class.
# - Implement `send_template_message` method in your child class.
# - Implement `sync_templates` method in your child class.
# - Implement `validate_provider_config` method in your child class.
# - Use Childclass.new(whatsapp_channel: channel).perform.
######################################

class Whatsapp::Providers::BaseService
  pattr_initialize [:whatsapp_channel!]

  def send_message(_phone_number, _message)
    raise 'Overwrite this method in child class'
  end

<<<<<<< HEAD
  def send_template(_phone_number, _template_info)
=======
  def send_template(_phone_number, _template_info, _message)
>>>>>>> upstream/develop
    raise 'Overwrite this method in child class'
  end

  def sync_template
    raise 'Overwrite this method in child class'
  end

  def validate_provider_config
    raise 'Overwrite this method in child class'
  end

  def error_message
    raise 'Overwrite this method in child class'
  end

<<<<<<< HEAD
  def process_response(response)
=======
  def process_response(response, message)
>>>>>>> upstream/develop
    parsed_response = response.parsed_response
    if response.success? && parsed_response['error'].blank?
      parsed_response['messages'].first['id']
    else
<<<<<<< HEAD
      handle_error(response)
=======
      handle_error(response, message)
>>>>>>> upstream/develop
      nil
    end
  end

<<<<<<< HEAD
  def handle_error(response)
    Rails.logger.error response.body
    return if @message.blank?
=======
  def handle_error(response, message)
    Rails.logger.error response.body
    return if message.blank?
>>>>>>> upstream/develop

    # https://developers.facebook.com/docs/whatsapp/cloud-api/support/error-codes/#sample-response
    error_message = error_message(response)
    return if error_message.blank?

<<<<<<< HEAD
    @message.external_error = error_message
    @message.status = :failed
    @message.save!
=======
    message.external_error = error_message
    message.status = :failed
    message.save!
>>>>>>> upstream/develop
  end

  def create_buttons(items)
    buttons = []
    items.each do |item|
      button = { :type => 'reply', 'reply' => { 'id' => item['value'], 'title' => item['title'] } }
      buttons << button
    end
    buttons
  end

  def create_rows(items)
    rows = []
    items.each do |item|
      row = { 'id' => item['value'], 'title' => item['title'] }
      rows << row
    end
    rows
  end

  def create_payload(type, message_content, action)
    {
      'type': type,
      'body': {
        'text': message_content
      },
      'action': action
    }
  end

  def create_payload_based_on_items(message)
    if message.content_attributes['items'].length <= 3
      create_button_payload(message)
    else
      create_list_payload(message)
    end
  end

  def create_button_payload(message)
    buttons = create_buttons(message.content_attributes['items'])
    json_hash = { 'buttons' => buttons }
<<<<<<< HEAD
    create_payload('button', message.content, JSON.generate(json_hash))
=======
    create_payload('button', message.outgoing_content, JSON.generate(json_hash))
>>>>>>> upstream/develop
  end

  def create_list_payload(message)
    rows = create_rows(message.content_attributes['items'])
    section1 = { 'rows' => rows }
    sections = [section1]
<<<<<<< HEAD
    json_hash = { :button => 'Choose an item', 'sections' => sections }
    create_payload('list', message.content, JSON.generate(json_hash))
=======
    json_hash = { :button => I18n.t('conversations.messages.whatsapp.list_button_label'), 'sections' => sections }
    create_payload('list', message.outgoing_content, JSON.generate(json_hash))
>>>>>>> upstream/develop
  end
end
