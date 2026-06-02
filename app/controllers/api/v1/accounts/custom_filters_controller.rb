class Api::V1::Accounts::CustomFiltersController < Api::V1::Accounts::BaseController
  before_action :check_authorization
<<<<<<< HEAD
  before_action :fetch_custom_filters, except: [:create]
=======
  before_action :fetch_custom_filters, only: [:index]
>>>>>>> upstream/develop
  before_action :fetch_custom_filter, only: [:show, :update, :destroy]
  DEFAULT_FILTER_TYPE = 'conversation'.freeze

  def index; end

  def show; end

  def create
<<<<<<< HEAD
    @custom_filter = current_user.custom_filters.create!(
      permitted_payload.merge(account_id: Current.account.id)
=======
    @custom_filter = Current.account.custom_filters.create!(
      permitted_payload.merge(user: Current.user)
>>>>>>> upstream/develop
    )
    render json: { error: @custom_filter.errors.messages }, status: :unprocessable_entity and return unless @custom_filter.valid?
  end

  def update
    @custom_filter.update!(permitted_payload)
  end

  def destroy
    @custom_filter.destroy!
    head :no_content
  end

  private

  def fetch_custom_filters
<<<<<<< HEAD
    @custom_filters = current_user.custom_filters.where(
      account_id: Current.account.id,
=======
    @custom_filters = Current.account.custom_filters.where(
      user: Current.user,
>>>>>>> upstream/develop
      filter_type: permitted_params[:filter_type] || DEFAULT_FILTER_TYPE
    )
  end

  def fetch_custom_filter
<<<<<<< HEAD
    @custom_filter = @custom_filters.find(permitted_params[:id])
=======
    @custom_filter = Current.account.custom_filters.where(
      user: Current.user
    ).find(permitted_params[:id])
>>>>>>> upstream/develop
  end

  def permitted_payload
    params.require(:custom_filter).permit(
      :name,
      :filter_type,
      query: {}
    )
  end

  def permitted_params
    params.permit(:id, :filter_type)
  end
end
