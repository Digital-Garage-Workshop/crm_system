class Public::Api::V1::Inboxes::ContactsController < Public::Api::V1::InboxesController
  before_action :contact_inbox, except: [:create, :update_push_token]
  before_action :process_hmac, except: [:create, :update_push_token]
  before_action :set_contact, only: [:update_push_token]

  def show
    render json: format_contact_response(@contact_inbox.contact)
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

    render json: format_contact_response(@contact_inbox.contact)
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    contact = contact_identify_action.perform
    render json: format_contact_response(contact)
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
    @contact.push_token = token
    @contact.plate_number = plate if plate

    if @contact.save
      Rails.logger.info "Successfully updated push token for contact ##{@contact.id}"
      render json: format_contact_response(@contact)
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

  private

  def format_contact_response(contact)
    contact_inbox = contact.contact_inboxes.find_by(inbox_id: @inbox_channel.inbox_id)

    {
      id: contact.id,
      name: contact.name,
      email: contact.email,
      phone_number: contact.phone_number,
      source_id: contact_inbox&.source_id,
      pubsub_token: contact.pubsub_token || generate_pubsub_token(contact)
    }
  end

  def generate_pubsub_token(contact)
    # Generate a pubsub token if not already present
    # This is a placeholder - implement according to your application's requirements
    token = SecureRandom.uuid
    contact.update(pubsub_token: token)
    token
  end

  def contact_inbox
    @contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:id])
  end

  def set_contact
    source_id = params[:source_id]
    Rails.logger.info "Looking up contact with source_id: #{source_id}"

    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by(source_id: source_id)

    if contact_inbox.nil?
      Rails.logger.error "No contact inbox found with source_id: #{source_id}"
      @contact = nil
      return
    end

    @contact = contact_inbox.contact
    Rails.logger.info "Found contact ##{@contact.id} for source_id: #{source_id}"
  rescue StandardError => e
    Rails.logger.error "Error finding contact: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @contact = nil
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
