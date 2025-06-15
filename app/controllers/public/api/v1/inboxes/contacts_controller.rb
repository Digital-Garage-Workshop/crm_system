class Public::Api::V1::Inboxes::ContactsController < Public::Api::V1::InboxesController
  before_action :contact_inbox, except: [:create, :update_push_token]
  before_action :process_hmac, except: [:create, :update_push_token]
  before_action :set_contact, only: [:update_push_token]

  def show
    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def create
    source_id = params[:source_id] || SecureRandom.uuid
    @contact_inbox = ::ContactInboxWithContactBuilder.new(
      source_id: source_id,
      inbox: @inbox_channel.inbox,
      contact_attributes: permitted_params.except(:identifier_hash)
    ).perform

    # Log the token for debugging
    Rails.logger.info "Contact created with ID: #{@contact_inbox.contact.id}, Push token present: #{permitted_params[:push_token].present?}"

    # Update push token if provided during creation
    if permitted_params[:push_token].present?
      @contact_inbox.contact.update(push_token: permitted_params[:push_token])
      Rails.logger.info "Push token set during contact creation for contact #{@contact_inbox.contact.id}"
    end

    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    updated_contact = contact_identify_action.perform

    # The contact_inbox remains the same even after the update
    render json: contact_response_json(updated_contact, @contact_inbox)
  end

  def update_push_token
    Rails.logger.info "Push token update request received for source_id: #{params[:source_id]}"
    Rails.logger.info "Params: #{params.to_json}"

    unless @contact
      Rails.logger.error "Contact not found for source_id: #{params[:source_id]}"
      return render json: { error: 'Contact not found' }, status: :not_found
    end

    token = params[:push_token].presence
    plate = params[:plate_number].presence

    Rails.logger.info "Processing push token update for contact ##{@contact.id}"
    Rails.logger.info "Token present: #{token.present?}, Plate present: #{plate.present?}"

    # Handle missing token
    unless token
      Rails.logger.error 'No push token provided in request'
      return render json: { error: 'No push token provided' }, status: :bad_request
    end

    # Directly update attributes for better error tracking
    @contact.push_token = token if @contact.respond_to?(:push_token=)
    @contact.plate_number = plate if plate && @contact.respond_to?(:plate_number=)

    if @contact.save
      Rails.logger.info "Successfully updated push token for contact ##{@contact.id}"
      # Find the appropriate contact_inbox for this contact
      inbox_contact = @inbox_channel.inbox.contact_inboxes.find_by(contact_id: @contact.id)
      render json: contact_response_json(@contact, inbox_contact)
    else
      Rails.logger.error "Failed to save push token: #{@contact.errors.full_messages.join(', ')}"
      render json: {
        error: @contact.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Exception in update_push_token: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: {
      error: 'An error occurred while processing your request',
      message: e.message
    }, status: :internal_server_error
  end

  # Add this new method for push token updates
  def update_push_token
    if @contact.update(push_token_params)
      render json: { success: true, message: 'Push token updated successfully' }
    else
      render json: { error: @contact.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def contact_response_json(contact, contact_inbox)
    # This ensures we don't try to access attributes that don't exist
    source_id = contact_inbox&.source_id || ''
    pubsub_token = contact.respond_to?(:pubsub_token) ? contact.pubsub_token : ''

    # If the token is missing and we should generate one
    if pubsub_token.blank? && contact.respond_to?(:pubsub_token=)
      begin
        pubsub_token = SecureRandom.uuid
        contact.update_column(:pubsub_token, pubsub_token) if contact.has_attribute?(:pubsub_token)
      rescue StandardError => e
        Rails.logger.error "Failed to generate pubsub_token: #{e.message}"
        pubsub_token = ''
      end
    end

    {
      id: contact.id,
      name: contact.name || '',
      email: contact.email,
      phone_number: contact.respond_to?(:phone_number) ? contact.phone_number : nil,
      source_id: source_id,
      pubsub_token: pubsub_token
    }
  end

  def contact_inbox
    @contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:id])
  end

  # Add this method to find contact by source_id
  def set_contact
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:source_id])
    @contact = contact_inbox.contact
  rescue ActiveRecord::RecordNotFound
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
    # Explicitly permit and extract only the parameters we need
    {
      push_token: params[:push_token],
      plate_number: params[:plate_number]
    }.compact
  end

  def permitted_params
    params.permit(:identifier, :identifier_hash, :email, :name, :avatar_url, :phone_number, :push_token, :plate_number, custom_attributes: {})
  end
end

# Add to your existing controller
def update_push_token
  source_id = params[:source_id]

  begin
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: source_id)
    @contact = contact_inbox.contact

    if @contact.update(push_token_params)
      Rails.logger.info "ContactsController: Updated push token for contact #{@contact.id}, source_id #{source_id}"
      render json: { success: true, message: 'Push token updated successfully' }
    else
      Rails.logger.error "ContactsController: Failed to update push token: #{@contact.errors.full_messages}"
      render json: { error: @contact.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "ContactsController: Failed to find contact with source_id #{source_id}: #{e.message}"
    render json: { error: 'Contact not found' }, status: :not_found
  end
end

# Add this to existing controller
private

def push_token_params
  params.permit(:push_token, :plate_number)
end
