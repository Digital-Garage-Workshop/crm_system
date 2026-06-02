class Api::V1::Accounts::SlaPoliciesController < Api::V1::Accounts::EnterpriseAccountsController
  before_action :fetch_sla, only: [:show, :update, :destroy]
  before_action :check_authorization

  def index
    @sla_policies = Current.account.sla_policies
  end

<<<<<<< HEAD
=======
  def show; end

>>>>>>> upstream/develop
  def create
    @sla_policy = Current.account.sla_policies.create!(permitted_params)
  end

<<<<<<< HEAD
  def show; end

=======
>>>>>>> upstream/develop
  def update
    @sla_policy.update!(permitted_params)
  end

  def destroy
<<<<<<< HEAD
    @sla_policy.destroy!
=======
    ::DeleteObjectJob.perform_later(@sla_policy, Current.user, request.ip) if @sla_policy.present?
>>>>>>> upstream/develop
    head :ok
  end

  def permitted_params
    params.require(:sla_policy).permit(:name, :description, :first_response_time_threshold, :next_response_time_threshold,
                                       :resolution_time_threshold, :only_during_business_hours)
  end

  def fetch_sla
    @sla_policy = Current.account.sla_policies.find_by(id: params[:id])
  end
end
