class Public::Api::V1::Inboxes::ContactsController < Public::Api::V1::InboxesController
  before_action :contact_inbox, except: [:create, :update_push_token]
  before_action :process_hmac, except: [:create, :update_push_token]
  before_action :set_contact, only: [:update_push_token]

  def show
    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def create
    @contact_inbox = build_contact_inbox
    renew_contact_push_token(@contact_inbox.contact) if permitted_params[:push_token].present?
    render json: contact_response_json(@contact_inbox.contact, @contact_inbox)
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    updated_contact = contact_identify_action.perform
    renew_contact_push_token(updated_contact) if permitted_params[:push_token].present?

    # The contact_inbox remains the same even after the update
    render json: contact_response_json(updated_contact, @contact_inbox)
  end

  def update_push_token
    return render_contact_not_found unless @contact
    return render_push_token_missing if params[:push_token].blank?

    update_contact_plate_number(@contact)
    renewed_contact = renew_contact_push_token(@contact)
    inbox_contact = @inbox_channel.inbox.contact_inboxes.find_by(contact_id: renewed_contact.id)
    render json: contact_response_json(renewed_contact, inbox_contact)
  rescue StandardError => e
    render_push_token_error(e)
  end

  private

  def build_contact_inbox
    source_id = params[:source_id] || SecureRandom.uuid
    ::ContactInboxWithContactBuilder.new(
      source_id: source_id,
      inbox: @inbox_channel.inbox,
      contact_attributes: permitted_params.except(:identifier_hash)
    ).perform
  end

  def contact_response_json(contact, contact_inbox)
    {
      id: contact.id,
      name: contact.name || '',
      email: contact.email,
      phone_number: contact.phone_number,
      source_id: contact_inbox&.source_id || '',
      pubsub_token: contact_inbox&.pubsub_token || ''
    }
  end

  def contact_inbox
    @contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:id])
  end

  def set_contact
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by(source_id: params[:source_id])
    @contact = contact_inbox&.contact
  end

  def update_contact_plate_number(contact)
    plate = params[:plate_number].presence
    return unless plate && contact.respond_to?(:plate_number=)

    contact.plate_number = plate
    contact.save! if contact.changed?
  end

  def render_contact_not_found
    render json: { error: 'Contact not found' }, status: :not_found
  end

  def render_push_token_missing
    render json: { error: 'No push token provided' }, status: :bad_request
  end

  def render_push_token_error(error)
    Rails.logger.error "Exception in update_push_token: #{error.class} - #{error.message}"
    render json: {
      error: 'An error occurred while processing your request',
      message: error.message
    }, status: :internal_server_error
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

  def renew_contact_push_token(contact)
    Contacts::PushTokenRenewalService.new(
      contact: contact,
      new_token: params[:push_token],
      old_token: params[:old_push_token]
    ).perform
  end

  def permitted_params
    params.permit(:identifier, :identifier_hash, :email, :name, :avatar_url, :phone_number, :push_token,
                  :old_push_token, :plate_number, custom_attributes: {})
  end
end
