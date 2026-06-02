class Api::V1::Accounts::MacrosController < Api::V1::Accounts::BaseController
<<<<<<< HEAD
=======
  include AttachmentConcern

>>>>>>> upstream/develop
  before_action :fetch_macro, only: [:show, :update, :destroy, :execute]
  before_action :check_authorization, only: [:show, :update, :destroy, :execute]

  def index
    @macros = Macro.with_visibility(current_user, params)
  end

  def show
    head :not_found if @macro.nil?
  end

  def create
<<<<<<< HEAD
    @macro = Current.account.macros.new(macros_with_user.merge(created_by_id: current_user.id))
    @macro.set_visibility(current_user, permitted_params)
    @macro.actions = params[:actions]

    render json: { error: @macro.errors.messages }, status: :unprocessable_entity and return unless @macro.valid?

    @macro.save!
    process_attachments
    @macro
  end

  def update
    ActiveRecord::Base.transaction do
      @macro.update!(macros_with_user)
      @macro.set_visibility(current_user, permitted_params)
      process_attachments
      @macro.save!
    rescue StandardError => e
      Rails.logger.error e
      render json: { error: @macro.errors.messages }.to_json, status: :unprocessable_entity
=======
    blobs, actions, error = validate_and_prepare_attachments(params[:actions])
    return render_could_not_create_error(error) if error

    @macro = Current.account.macros.new(macros_with_user.merge(created_by_id: current_user.id))
    @macro.set_visibility(current_user, permitted_params)
    @macro.actions = actions

    return render_could_not_create_error(@macro.errors.messages) unless @macro.valid?

    @macro.save!
    blobs.each { |blob| @macro.files.attach(blob) }
  end

  def update
    blobs, actions, error = validate_and_prepare_attachments(params[:actions], @macro)
    return render_could_not_create_error(error) if error

    ActiveRecord::Base.transaction do
      @macro.assign_attributes(macros_with_user)
      @macro.set_visibility(current_user, permitted_params)
      @macro.actions = actions if params[:actions]
      @macro.save!
      blobs.each { |blob| @macro.files.attach(blob) }
    rescue StandardError => e
      Rails.logger.error e
      render_could_not_create_error(@macro.errors.messages)
>>>>>>> upstream/develop
    end
  end

  def destroy
    @macro.destroy!
    head :ok
  end

  def execute
    ::MacrosExecutionJob.perform_later(@macro, conversation_ids: params[:conversation_ids], user: Current.user)

    head :ok
  end

  private

<<<<<<< HEAD
  def process_attachments
    actions = @macro.actions.filter_map { |k, _v| k if k['action_name'] == 'send_attachment' }
    return if actions.blank?

    actions.each do |action|
      blob_id = action['action_params']
      blob = ActiveStorage::Blob.find_by(id: blob_id)
      @macro.files.attach(blob)
    end
  end

  def permitted_params
    params.permit(
      :name, :account_id, :visibility,
=======
  def permitted_params
    params.permit(
      :name, :visibility,
>>>>>>> upstream/develop
      actions: [:action_name, { action_params: [] }]
    )
  end

  def macros_with_user
    permitted_params.merge(updated_by_id: current_user.id)
  end

  def fetch_macro
    @macro = Current.account.macros.find_by(id: params[:id])
  end

  def check_authorization
    authorize(@macro) if @macro.present?
  end
end
