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
  end

  def update
    contact_identify_action = ContactIdentifyAction.new(
      contact: @contact_inbox.contact,
      params: permitted_params.to_h.deep_symbolize_keys.except(:identifier)
    )
    render json: contact_identify_action.perform
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

  def permitted_params
    params.permit(:identifier, :identifier_hash, :email, :name, :avatar_url, :phone_number, :push_token, :plate_number, custom_attributes: {})
  end

  # Add a separate method for push token updates
  def push_token_params
    params.permit(:push_token, :plate_number)
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
