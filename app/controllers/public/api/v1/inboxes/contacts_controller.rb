class Public::Api::V1::Inboxes::ContactsController < Public::Api::V1::InboxesController
  before_action :contact_inbox, except: [:create, :update_push_token]
  before_action :process_hmac, except: [:update_push_token]
  before_action :set_contact, only: [:update_push_token]

  def show; end

  def create
    source_id = params[:source_id] || SecureRandom.uuid
    @contact_inbox = ::ContactInboxWithContactBuilder.new(
      source_id: source_id,
      inbox: @inbox_channel.inbox,
      contact_attributes: permitted_params.except(:identifier_hash)
    ).perform

    # Log the token for debugging
    Rails.logger.info "Contact created with ID: #{@contact_inbox.contact.id}, Push token present: #{permitted_params[:push_token].present?}"
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    render json: contact_identify_action.perform
  end

  # Enhanced method for push token updates with logging
  def update_push_token
    if update_contact_with_token
      render_success_response
    else
      render_validation_errors
    end
  rescue StandardError => e
    handle_generic_error(e)
  end

  private

  def find_contact_and_update_token(source_id)
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: source_id)
    @contact = contact_inbox.contact

    if update_contact_with_token
      render_success_response
    else
      render_validation_errors
    end
  end

  def update_contact_with_token
    log_token_update_attempt
    @contact.update(push_token_params)
  end

  def log_token_update_attempt
    Rails.logger.info "Updating push token for contact #{@contact.id}, token present: #{params[:push_token].present?}"
  end

  def render_success_response
    Rails.logger.info "Push token updated successfully for contact #{@contact.id}"
    render json: { success: true, message: 'Push token updated successfully' }
  end

  def render_validation_errors
    Rails.logger.error "Failed to update push token: #{@contact.errors.full_messages}"
    render json: { error: @contact.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  def handle_contact_not_found(source_id, exception)
    Rails.logger.error "Failed to find contact with source_id #{source_id}: #{exception.message}"
    render json: { error: 'Contact not found' }, status: :not_found
  end

  def handle_generic_error(exception)
    Rails.logger.error "Error during push token update: #{exception.class} - #{exception.message}"
    render json: { error: 'An error occurred while processing your request' }, status: :internal_server_error
  end

  def push_token_params
    params.permit(:push_token, :plate_number)
  end

  def contact_inbox
    @contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:id])
  end

  def set_contact
    contact_inbox = @inbox_channel.inbox.contact_inboxes.find_by!(source_id: params[:source_id])
    @contact = contact_inbox.contact
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "ContactsController: Failed to find contact with source_id #{params[:source_id]}: #{e.message}"
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

  def permitted_params
    params.permit(:identifier, :identifier_hash, :email, :name, :avatar_url, :phone_number, :push_token, :plate_number, custom_attributes: {})
  end
end
