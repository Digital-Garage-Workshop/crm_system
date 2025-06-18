class Public::Api::V1::Inboxes::ContactsController < Public::Api::V1::InboxesController
  before_action :contact_inbox, except: [:create, :update_push_token]
  before_action :process_hmac, except: [:create, :update_push_token]
  before_action :set_contact, only: [:update_push_token]

  def show
    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def create
    Rails.logger.info '=== CREATE CONTACT DEBUG ==='
    Rails.logger.info "Permitted params: #{permitted_params.to_json}"

    source_id = params[:source_id] || SecureRandom.uuid
    @contact_inbox = ::ContactInboxWithContactBuilder.new(
      source_id: source_id,
      inbox: @inbox_channel.inbox,
      contact_attributes: permitted_params.except(:identifier_hash)
    ).performcontact.json.jbuilder

    Rails.logger.info "Contact created - ID: #{@contact_inbox.contact.id}, Plate: #{@contact_inbox.contact.plate_number}"

    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    updated_contact = contact_identify_action.perform

    render json: contact_response_json(updated_contact, @contact_inbox)
  end

  def update_push_token
    Rails.logger.info "Push token update request received for source_id: #{params[:source_id]}"

    unless @contact
      Rails.logger.error "Contact not found for source_id: #{params[:source_id]}"
      return render json: { error: 'Contact not found' }, status: :not_found
    end

    if @contact.update(push_token_params)
      Rails.logger.info "Successfully updated contact ##{@contact.id}"
      contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by(contact_id: @contact.id)
      render json: contact_response_json(@contact, contact_inbox)
    else
      Rails.logger.error "Failed to update contact: #{@contact.errors.full_messages.join(', ')}"
      render json: {
        error: @contact.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Exception in update_push_token: #{e.class} - #{e.message}"
    render json: {
      error: 'An error occurred while processing your request',
      message: e.message
    }, status: :internal_server_error
  end

  private

  def contact_response_json(contact, contact_inbox)
    Rails.logger.info '=== CONTACT RESPONSE JSON DEBUG ==='
    Rails.logger.info "Contact ID: #{contact.id}, Plate Number: #{contact.plate_number.inspect}"

    source_id = contact_inbox&.source_id || ''
    pubsub_token = contact.respond_to?(:pubsub_token) ? contact.pubsub_token : ''

    # Generate pubsub_token if missing
    if pubsub_token.blank? && contact.respond_to?(:pubsub_token=)
      begin
        pubsub_token = SecureRandom.uuid
        contact.update_column(:pubsub_token, pubsub_token) if contact.has_attribute?(:pubsub_token)
      rescue StandardError => e
        Rails.logger.error "Failed to generate pubsub_token: #{e.message}"
        pubsub_token = ''
      end
    end

    response = {
      id: contact.id,
      name: contact.name || '',
      email: contact.email,
      phone_number: contact.phone_number,
      plate_number: contact.plate_number,
      source_id: source_id,
      pubsub_token: pubsub_token
    }

    Rails.logger.info "API Response: #{response.to_json}"
    response
  end

  def contact_inbox
    @contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:id])
  end

  def set_contact
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:source_id])
    @contact = contact_inbox.contact
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Contact not found for source_id: #{params[:source_id]}"
    render json: { error: 'Contact not found' }, status: :not_found
  end

  def process_hmac
    return if params[:identifier_hash].blank? && !@inbox_channel.hmac_mandatory
    raise StandardError, 'HMAC failed: Invalid Identifier Hash Provided' unless valid_hmac?

    @contact_inbox.update(hmac_verified: true) if @contact_inbox.present?
  end

  def valid_hmac?
    params[:identifier_hash] == OpenSSL::HMAC.hexdigest(
      'sha256',
      @inbox_channel.hmac_token,
      params[:identifier].to_s
    )
  end

  # aaa
  def push_token_params
    params.permit(:push_token, :plate_number)
  end

  def permitted_params
    params.permit(:identifier, :identifier_hash, :email, :name, :avatar_url, :phone_number, :push_token, :plate_number, custom_attributes: {})
  end

  # Add a separate method for push token updates
end
