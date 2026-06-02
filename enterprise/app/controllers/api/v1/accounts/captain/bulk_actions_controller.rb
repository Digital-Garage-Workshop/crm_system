class Api::V1::Accounts::Captain::BulkActionsController < Api::V1::Accounts::BaseController
  before_action :current_account
  before_action -> { check_authorization(Captain::Assistant) }
  before_action :validate_params
  before_action :type_matches?

<<<<<<< HEAD
  MODEL_TYPE = ['AssistantResponse'].freeze

  def create
    @responses = process_bulk_action
=======
  MODEL_TYPE = %w[AssistantResponse AssistantDocument].freeze

  def create
    result = process_bulk_action
    return if performed?

    @responses = result
>>>>>>> upstream/develop
  end

  private

  def validate_params
    return if params[:type].present? && params[:ids].present? && params[:fields].present?

<<<<<<< HEAD
    render json: { success: false }, status: :unprocessable_entity
=======
    render json: { success: false }, status: :unprocessable_content
>>>>>>> upstream/develop
  end

  def type_matches?
    return if MODEL_TYPE.include?(params[:type])

<<<<<<< HEAD
    render json: { success: false }, status: :unprocessable_entity
=======
    render json: { success: false }, status: :unprocessable_content
>>>>>>> upstream/develop
  end

  def process_bulk_action
    case params[:type]
    when 'AssistantResponse'
      handle_assistant_responses
<<<<<<< HEAD
=======
    when 'AssistantDocument'
      handle_documents
>>>>>>> upstream/develop
    end
  end

  def handle_assistant_responses
    responses = Current.account.captain_assistant_responses.where(id: params[:ids])
    return unless responses.exists?

    case params[:fields][:status]
    when 'approve'
      responses.pending.update(status: 'approved')
      responses
    when 'delete'
      responses.destroy_all
      []
    end
  end

<<<<<<< HEAD
=======
  def handle_documents
    case params[:fields][:status]
    when 'delete'
      delete_documents
    when 'sync'
      sync_documents
    else
      []
    end
  end

  def delete_documents
    documents = Current.account.captain_documents.where(id: params[:ids])
    return render json: { count: 0 } unless documents.exists?

    destroyed_documents = documents.destroy_all
    render json: { count: destroyed_documents.size }
  end

  def sync_documents
    synced_document_ids = []

    Current.account.captain_documents.where(id: params[:ids]).find_each(batch_size: 100) do |document|
      next unless document.syncable?
      next unless document.available?

      document.update!(
        sync_status: :syncing,
        sync_step: nil,
        last_sync_error_code: nil,
        last_sync_attempted_at: Time.current
      )
      Captain::Documents::PerformSyncJob.perform_later(document)
      synced_document_ids << document.id
    end

    render json: { ids: synced_document_ids, count: synced_document_ids.size }
  end

>>>>>>> upstream/develop
  def permitted_params
    params.permit(:type, ids: [], fields: [:status])
  end
end
